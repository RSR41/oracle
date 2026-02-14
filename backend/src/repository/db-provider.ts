export type DbProvider = 'prisma' | 'supabase' | 'firebase';

export function resolveDbProvider(rawProvider?: string): DbProvider {
  const provider = (rawProvider || 'prisma').toLowerCase();

  if (provider === 'prisma' || provider === 'supabase' || provider === 'firebase') {
    return provider;
  }

  throw new Error(`Unsupported DB_PROVIDER: ${rawProvider}`);
}
