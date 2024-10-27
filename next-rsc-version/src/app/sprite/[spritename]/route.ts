// An unnecessary optimization, but a fun one :)

import { NextRequest } from "next/server";

// Cache the sprites indefinitely
export const maxDuration = 60 * 60 * 24;

export async function GET(
  _request: NextRequest,
  { params }: { params: Promise<{ spritename: string }> }
) {
  const { spritename } = await params;

  // Make sure spritename matches format {id}.png (use a regex)
  if (!/^\d+\.png$/.test(spritename)) {
    return new Response("Not found", { status: 404 });
  }

  const dexId = parseInt(spritename.split(".")[0]);

  const spriteFromGithub = await fetch(
    `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${dexId}.png`
  );

  return new Response(spriteFromGithub.body, {
    headers: {
      "Content-Type": "image/png",
      "Cache-Control": "public, max-age=31536000, immutable",
      "CDN-Cache-Control": "public, max-age=31536000, immutable",
      "Vercel-CDN-Cache-Control": "public, max-age=31536000, immutable",
    },
  });
}