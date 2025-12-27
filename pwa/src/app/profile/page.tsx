'use client';

import { useState, useEffect } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import ProfileForm from '@/components/ProfileForm';
import { getProfileId } from '@/lib/storage';

export default function ProfilePage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const token = searchParams.get('token');
  
  const [hasExistingProfile, setHasExistingProfile] = useState(false);

  useEffect(() => {
    const existingProfileId = getProfileId();
    setHasExistingProfile(!!existingProfileId);
  }, []);

  function handleSuccess() {
    if (token) {
      // ?쒓렇?먯꽌 ?붿쑝硫??ㅼ떆 ?쒓렇 ?섏씠吏濡?
      router.push(`/tag/${token}`);
    } else {
      // 吏곸젒 ?묒냽?덉쑝硫??덉쑝濡?
      router.push('/');
    }
  }

  return (
    <main className="min-h-screen p-6 pb-24">
      <div className="max-w-md mx-auto space-y-6">
        {/* ?ㅻ뜑 */}
        <div className="text-center space-y-2">
          <div className="w-16 h-16 mx
          -auto bg-gradient-to-br from-primary-500 to-primary-700 rounded-full flex items-center justify-center">
<span className="text-2xl">?뱷</span>
</div>
<h1 className="text-2xl font-bold text-gray-900">
{hasExistingProfile ? '?꾨줈???섏젙' : '?꾨줈???낅젰'}
</h1>
<p className="text-sm text-gray-600">
?뺥솗???댁꽭 遺꾩꽍???꾪빐<br />
?앸뀈?붿씪 ?뺣낫瑜??낅젰?댁＜?몄슂
</p>
</div>
    {/* ?꾨줈????*/}
    <ProfileForm onSuccess={handleSuccess} />

    {/* 媛쒖씤?뺣낫 蹂댄샇 ?덈궡 */}
    <div className="card-bordered bg-blue-50 border-blue-200">
      <div className="flex items-start space-x-3">
        <span className="text-xl">?뵏</span>
        <div className="flex-1 space-y-2">
          <h3 className="font-semibold text-gray-900 text-sm">媛쒖씤?뺣낫 蹂댄샇</h3>
          <ul className="text-xs text-gray-600 space-y-1">
            <li>???낅젰?섏떊 ?뺣낫???댁꽭 遺꾩꽍?먮쭔 ?ъ슜?⑸땲??/li>
            <li>??NFC ?쒓렇?먮뒗 媛쒖씤?뺣낫媛 ??λ릺吏 ?딆뒿?덈떎</li>
            <li>???몄젣?좎? ?꾨줈?꾩쓣 ?섏젙/??젣?????덉뒿?덈떎</li>
          </ul>
        </div>
      </div>
    </div>

    {/* ?ㅻ씫/李멸퀬??怨좎? */}
    <p className="text-xs text-gray-500 text-center">
      蹂??쒕퉬?ㅻ뒗 ?ㅻ씫 諛?李멸퀬?⑹쑝濡??쒓났?⑸땲??
    </p>
  </div>
</main>
);
}
