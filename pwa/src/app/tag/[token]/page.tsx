'use client';

import { useEffect, useState } from 'react';
import { useRouter, useParams } from 'next/navigation';
import Link from 'next/link';
import { getTagInfo, getFortuneSnapshot } from '@/lib/api';
import { getProfileId } from '@/lib/storage';
import { TagInfo, FortuneSnapshot } from '@/types';
import LoadingSpinner from '@/components/LoadingSpinner';
import ErrorMessage from '@/components/ErrorMessage';
import FortuneScore from '@/components/FortuneScore';
import { formatDateForDisplay } from '@/lib/utils';

export default function TagPage() {
  const router = useRouter();
  const params = useParams();
  const token = params.token as string;

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [tagInfo, setTagInfo] = useState<TagInfo | null>(null);
  const [snapshot, setSnapshot] = useState<FortuneSnapshot | null>(null);

  useEffect(() => {
    loadTagData();
  }, [token]);

  async function loadTagData() {
    setLoading(true);
    setError(null);

    // 1. ?쒓렇 ?뺣낫 議고쉶
    const tagResponse = await getTagInfo(token);
    if (!tagResponse.success || !tagResponse.data) {
      setError(tagResponse.error?.message || '?쒓렇 ?뺣낫瑜?遺덈윭?????놁뒿?덈떎');
      setLoading(false);
      return;
    }

    const tagData = tagResponse.data;
    setTagInfo(tagData);

    // 2. 鍮꾪솢???쒓렇 泥댄겕
    if (!tagData.isActive) {
      setError('鍮꾪솢?깊솕???쒓렇?낅땲?? 怨좉컼?쇳꽣??臾몄쓽?댁＜?몄슂.');
      setLoading(false);
      return;
    }

    // 3. ?꾨줈???뺤씤
    const profileId = getProfileId();
    if (!profileId && tagData.requiresProfile) {
      // ?꾨줈?꾩씠 ?놁쑝硫??꾨줈???낅젰 ?섏씠吏濡??대룞
      router.push(`/profile?token=${token}`);
      return;
    }

    // 4. ?댁꽭 ?ㅻ깄酉?議고쉶
    if (profileId) {
      const snapshotResponse = await getFortuneSnapshot(profileId, token);
      if (snapshotResponse.success && snapshotResponse.data) {
        setSnapshot(snapshotResponse.data);
      } else {
        setError(snapshotResponse.error?.message || '?댁꽭瑜?遺덈윭?????놁뒿?덈떎');
      }
    }

    setLoading(false);
  }

  if (loading) {
    return (
      <main className="min-h-screen flex items-center justify-center p-6">
        <LoadingSpinner message="?댁꽭瑜?遺덈윭?ㅻ뒗 以?.." size="lg" />
      </main>
    );
  }

  if (error) {
    return (
      <main className="min-h-screen flex items-center justify-center p-6">
        <div className="max-w-md w-full space-y-6">
          <ErrorMessage message={error} onRetry={loadTagData} />
          <Link href="/" className="block btn-secondary text-center">
            ?덉쑝濡??뚯븘媛湲?
          </Link>
        </div>
      </main>
    );
  }

  if (!snapshot) {
    return null;
  }

  return (
    <main className="min-h-screen p-6 pb-24">
      <div className="max-w-md mx-auto space-y-6">
        {/* ?ㅻ뜑 */}
        <div className="text-center space-y-2">
          <p className="text-sm text-gray-600">
            {formatDateForDisplay(snapshot.date)}
          </p>
          <h1 className="text-2xl font-bold text-gray-900">
            ?ㅻ뒛???댁꽭
          </h1>
        </div>

        {/* ?댁꽭 ?먯닔 */}
        <div className="card text-center space-y-4">
          <FortuneScore score={snapshot.score} size="lg" />
          <p className="text-lg text-gray-900 font-medium">
            {snapshot.oneLiner}
          </p>
        </div>

        {/* ?ㅼ썙??*/}
        <div className="card">
          <h2 className="text-sm font-semibold text-gray-700 mb-3">?ㅻ뒛???ㅼ썙??/h2>
          <div className="flex flex-wrap gap-2">
            {snapshot.keywords.map((keyword, index) => (
              <span
                key={index}
                className="px-4 py-2 bg-primary-100 text-primary-700 rounded-full text-sm font-medium"
              >
                #{keyword}
              </span>
            ))}
          </div>
        </div>

        {/* 誘몃━蹂닿린 */}
        <div className="space-y-3">
          <h2 className="text-lg font-bold text-gray-900">?몃? ?댁꽭 誘몃━蹂닿린</h2>
          
          <div className="card space-y-4">
            <PreviewItem icon="?뮆" title="?좎젙?? content={snapshot.preview.love} />
            <PreviewItem icon="?뮥" title="湲덉쟾?? content={snapshot.preview.money} />
            <PreviewItem icon="?뮞" title="嫄닿컯?? content={snapshot.preview.health} />
            <PreviewItem icon="?뮳" title="吏곸뾽?? content={snapshot.preview.work} />
          </div>
        </div>

        {/* CTA - ?꾩껜 蹂닿린 */}
        <div className="card bg-gradient-to-br from-primary-500 to-primary-700 text-white text-center space-y-4">
          <div className="space-y-2">
            <p className="text-2xl">?럞</p>
            <h3 className="text-lg font-bold">?ㅻ쭅 ?뚯쑀???꾩슜 ?쒗깮</h3>
            <p className="text-sm opacity-90">
              泥댄겕?명븯怨??ㅻ뒛???꾩껜 ?댁꽭瑜??뺤씤?섏꽭??
            </p>
          </div>
          <Link
            href={`/result/today?token=${token}`}
            className="block w-full bg-white text-primary-600 px-6 py-3 rounded-lg font-semibold hover:bg-gray-50 transition-colors"
          >
            ?ㅻ뒛 ?꾩껜 蹂닿린 (泥댄겕??
          </Link>
        </div>

        {/* ?ㅻ씫/李멸퀬??怨좎? */}
        <p className="text-xs text-gray-500 text-center">
          蹂??쒕퉬?ㅻ뒗 ?ㅻ씫 諛?李멸퀬?⑹쑝濡??쒓났?⑸땲??
        </p>
      </div>
    </main>
  );
}

function PreviewItem({ icon, title, content }: { icon: string; title: string; content: string }) {
  return (
    <div className="flex items-start space-x-3 pb-4 border-b border-gray-100 last:border-0 last:pb-0">
      <span className="text-2xl">{icon}</span>
      <div className="flex-1">
        <h4 className="font-semibold text-gray-900 mb-1">{title}</h4>
        <p className="text-sm text-gray-600">{content}</p>
      </div>
    </div>
  );
}
