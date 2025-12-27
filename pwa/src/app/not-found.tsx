import Link from 'next/link';

export default function NotFound() {
  return (
    <main className="min-h-screen flex items-center justify-center p-6">
      <div className="max-w-md w-full text-center space-y-6">
        <div className="text-6xl">?뵇</div>
        <h1 className="text-2xl font-bold text-gray-900">
          ?섏씠吏瑜?李얠쓣 ???놁뒿?덈떎
        </h1>
        <p className="text-gray-600">
          ?붿껌?섏떊 ?섏씠吏媛 議댁옱?섏? ?딄굅??br />
          ?대룞?섏뿀?????덉뒿?덈떎.
        </p>
        <Link href="/" className="inline-block btn-primary">
          ?덉쑝濡??뚯븘媛湲?
        </Link>
      </div>
    </main>
  );
}
