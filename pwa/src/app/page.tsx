import Link from 'next/link';

export default function Home() {
  return (
    <main className="min-h-screen flex flex-col items-center justify-center p-6">
      <div className="max-w-md w-full space-y-8 text-center">
        <div className="space-y-4">
          <div className="w-24 h-24 mx-auto bg-gradient-to-br from-primary-500 to-primary-700 rounded-full flex items-center justify-center shadow-xl">
            <span className="text-4xl">?뵰</span>
          </div>
          <h1 className="text-4xl font-bold text-gray-900">
            Oracle
          </h1>
          <p className="text-lg text-gray-600">
            ?ㅻ쭅 ?섎굹濡?鍮좊Ⅴ寃??뺤씤?섎뒗<br />
            ?ㅻ뒛???댁꽭
          </p>
        </div>

        <div className="card space-y-4 animate-fade-in">
          <div className="text-left space-y-3">
            <div className="flex items-start space-x-3">
              <span className="text-2xl">??/span>
              <div>
                <h3 className="font-semibold text-gray-900">NFC ?ㅻ쭅???쒓렇?섏꽭??/h3>
                <p className="text-sm text-gray-600">3珥??덉뿉 ?ㅻ뒛???댁꽭瑜??뺤씤?????덉뒿?덈떎</p>
              </div>
            </div>
            
            <div className="flex items-start space-x-3">
              <span className="text-2xl">?럞</span>
              <div>
                <h3 className="font-semibold text-gray-900">?ㅻ쭅 ?뚯쑀???꾩슜 ?쒗깮</h3>
                <p className="text-sm text-gray-600">留ㅼ씪 泥댄겕?몄쑝濡??꾩껜 由ы룷?몃? ?뺤씤?섏꽭??/p>
              </div>
            </div>
          </div>
        </div>

        {process.env.NEXT_PUBLIC_MOCK_MODE === 'true' && (
          <div className="space-y-3">
            <p className="text-sm text-gray-500">媛쒕컻 紐⑤뱶 - ?뚯뒪??留곹겕</p>
            <div className="space-y-2">
              <Link href="/tag/demo-token-123" className="block btn-primary">
                ?뚯뒪???쒓렇 泥댄뿕?섍린
              </Link>
              <Link href="/profile" className="block btn-secondary">
                ?꾨줈???낅젰?섍린
              </Link>
            </div>
          </div>
        )}

        <div className="pt-6">
          <Link href="/install" className="text-primary-600 hover:underline text-sm">
            ???ㅼ튂?섍린 ??
          </Link>
        </div>

        <p className="text-xs text-gray-500 pt-4">
          蹂??쒕퉬?ㅻ뒗 ?ㅻ씫 諛?李멸퀬?⑹쑝濡??쒓났?⑸땲??
        </p>
      </div>
    </main>
  );
}
