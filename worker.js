/* Direct du concert : l'étape en cours (chant ou saynète), envoyée à tous les téléphones.
   Les fichiers du site sont servis directement par Cloudflare ; ce script ne reçoit que /live/…
   - GET  /live/ws     : WebSocket, reçoit {i, n} à chaque changement (i : voir etatDe dans paroles/live.js)
   - GET  /live/etat   : {i, n} (secours si le WebSocket ne passe pas)
   - POST /live/etape  : {k, i} — k = code de la télécommande (son empreinte SHA-256 est dans wrangler.jsonc) */
import { DurableObject } from 'cloudflare:workers';

const json = (o, status = 200) => new Response(JSON.stringify(o), { status, headers: { 'content-type': 'application/json', 'cache-control': 'no-store' } });

async function sha256(t) {
  const h = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(t));
  return [...new Uint8Array(h)].map(b => b.toString(16).padStart(2, '0')).join('');
}

export class Direct extends DurableObject {
  async etat() {
    return { i: (await this.ctx.storage.get('i')) ?? -1, n: this.ctx.getWebSockets().length };
  }

  async fetch(req) {
    const url = new URL(req.url);
    if (url.pathname === '/live/ws') {
      if (req.headers.get('Upgrade') !== 'websocket') return new Response('WebSocket attendu', { status: 426 });
      const [client, server] = Object.values(new WebSocketPair());
      this.ctx.acceptWebSocket(server);   // mode « hibernation » : rien ne tourne entre deux messages
      server.send(JSON.stringify(await this.etat()));
      return new Response(null, { status: 101, webSocket: client });
    }
    if (url.pathname === '/live/etape' && req.method === 'POST') {
      const { i } = await req.json();
      await this.ctx.storage.put('i', i);
      const msg = JSON.stringify(await this.etat());
      for (const ws of this.ctx.getWebSockets()) try { ws.send(msg); } catch {}
      return new Response(msg, { headers: { 'content-type': 'application/json' } });
    }
    return json(await this.etat());
  }

  webSocketMessage(ws) { ws.send('{"pong":1}'); }   // maintien de la connexion
  webSocketClose(ws, code) { try { ws.close(code); } catch {} }
}

export default {
  async fetch(req, env) {
    const url = new URL(req.url);
    if (!url.pathname.startsWith('/live/')) return env.ASSETS.fetch(req);
    if (url.pathname === '/live/etape') {
      if (req.method !== 'POST') return json({ error: 'POST attendu' }, 405);
      let body;
      try { body = await req.json(); } catch { return json({ error: 'JSON attendu' }, 400); }
      if (typeof body.k !== 'string' || (await sha256(body.k)) !== env.TELECOMMANDE_HASH) return json({ error: 'code de télécommande incorrect' }, 403);
      if (!Number.isInteger(body.i) || body.i < -1 || body.i > 200) return json({ error: 'étape invalide' }, 400);
      req = new Request(req.url, { method: 'POST', body: JSON.stringify({ i: body.i }) });
    } else if (!['/live/ws', '/live/etat'].includes(url.pathname)) return json({ error: 'inconnu' }, 404);
    return env.DIRECT.get(env.DIRECT.idFromName('concert')).fetch(req);
  },
};
