import React, { useState } from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { ArrowLeft, Sparkles, RefreshCw, Image as ImageIcon } from 'lucide-react';
import { motion } from 'motion/react';
import { ImageWithFallback } from '@/app/components/figma/ImageWithFallback';

interface IdealTypeProps {
  onBack: () => void;
  data?: any;
}

export const IdealType: React.FC<IdealTypeProps> = ({ onBack, data }) => {
  const { t } = useApp();
  const [step, setStep] = useState<'setup' | 'generating' | 'result'>('setup');
  const [options, setOptions] = useState({
    purpose: 'lover',
    style: 'realistic',
    mood: 'warm',
  });
  const [generatedImages, setGeneratedImages] = useState<string[]>([]);

  const handleGenerate = () => {
    setStep('generating');
    
    // Simulate generation
    setTimeout(() => {
      // Using placeholder images
      setGeneratedImages([
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&h=600&fit=crop',
        'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=400&h=600&fit=crop',
      ]);
      setStep('result');
    }, 3000);
  };

  if (step === 'setup') {
    return (
      <div className="min-h-screen pb-20">
        {/* Header */}
        <div className="px-5 pt-6 pb-4 flex items-center gap-3">
          <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
            <ArrowLeft size={24} className="text-foreground" />
          </button>
          <div>
            <h1 className="text-2xl font-semibold text-foreground">{t('ideal.title')}</h1>
          </div>
        </div>

        {/* Info */}
        <div className="px-5 mb-6">
          <div className="bg-primary/5 border border-primary/20 rounded-2xl p-5">
            <div className="flex items-start gap-3">
              <div className="bg-primary/10 p-2 rounded-lg">
                <Sparkles className="text-primary" size={20} />
              </div>
              <div className="flex-1">
                <h3 className="font-semibold text-foreground mb-2">이상형 생성 안내</h3>
                <ul className="text-sm text-muted-foreground space-y-1.5">
                  <li>• 관상 분석 결과를 바탕으로 생성됩니다</li>
                  <li>• 실존 인물과 닮은꼴은 생성되지 않습니다</li>
                  <li>• 결과는 참고용이며 취향에 따라 다를 수 있습니다</li>
                  <li>• 생성된 이미지는 언제든 삭제 가능합니다</li>
                </ul>
              </div>
            </div>
          </div>
        </div>

        {/* Options */}
        <div className="px-5 mb-6 space-y-6">
          {/* Purpose */}
          <div>
            <h3 className="font-semibold text-foreground mb-3">{t('ideal.purpose')}</h3>
            <div className="grid grid-cols-2 gap-3">
              {[
                { id: 'friend', label: t('ideal.friend'), icon: '👫' },
                { id: 'lover', label: t('ideal.lover'), icon: '💕' },
              ].map((item) => (
                <button
                  key={item.id}
                  onClick={() => setOptions({ ...options, purpose: item.id })}
                  className={`p-4 rounded-2xl border-2 transition-all ${
                    options.purpose === item.id
                      ? 'border-primary bg-primary/5'
                      : 'border-border bg-card hover:border-primary/50'
                  }`}
                >
                  <div className="text-3xl mb-2">{item.icon}</div>
                  <div className={`text-sm font-medium ${
                    options.purpose === item.id ? 'text-primary' : 'text-foreground'
                  }`}>
                    {item.label}
                  </div>
                </button>
              ))}
            </div>
          </div>

          {/* Style */}
          <div>
            <h3 className="font-semibold text-foreground mb-3">{t('ideal.style')}</h3>
            <div className="grid grid-cols-2 gap-3">
              {[
                { id: 'realistic', label: t('ideal.realistic'), icon: '📸' },
                { id: 'illustration', label: t('ideal.illustration'), icon: '🎨' },
              ].map((item) => (
                <button
                  key={item.id}
                  onClick={() => setOptions({ ...options, style: item.id })}
                  className={`p-4 rounded-2xl border-2 transition-all ${
                    options.style === item.id
                      ? 'border-primary bg-primary/5'
                      : 'border-border bg-card hover:border-primary/50'
                  }`}
                >
                  <div className="text-3xl mb-2">{item.icon}</div>
                  <div className={`text-sm font-medium ${
                    options.style === item.id ? 'text-primary' : 'text-foreground'
                  }`}>
                    {item.label}
                  </div>
                </button>
              ))}
            </div>
          </div>

          {/* Mood */}
          <div>
            <h3 className="font-semibold text-foreground mb-3">{t('ideal.mood')}</h3>
            <div className="grid grid-cols-2 gap-3">
              {[
                { id: 'warm', label: t('ideal.warm'), icon: '☀️' },
                { id: 'chic', label: t('ideal.chic'), icon: '🌙' },
              ].map((item) => (
                <button
                  key={item.id}
                  onClick={() => setOptions({ ...options, mood: item.id })}
                  className={`p-4 rounded-2xl border-2 transition-all ${
                    options.mood === item.id
                      ? 'border-primary bg-primary/5'
                      : 'border-border bg-card hover:border-primary/50'
                  }`}
                >
                  <div className="text-3xl mb-2">{item.icon}</div>
                  <div className={`text-sm font-medium ${
                    options.mood === item.id ? 'text-primary' : 'text-foreground'
                  }`}>
                    {item.label}
                  </div>
                </button>
              ))}
            </div>
          </div>
        </div>

        {/* Generate Button */}
        <div className="px-5">
          <button
            onClick={handleGenerate}
            className="w-full bg-gradient-to-r from-primary to-[#C4A574] text-white py-4 rounded-2xl font-semibold shadow-lg hover:shadow-xl transition-shadow"
          >
            이상형 생성하기
          </button>
        </div>
      </div>
    );
  }

  if (step === 'generating') {
    return (
      <div className="min-h-screen flex items-center justify-center px-5 pb-20">
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          className="text-center"
        >
          <motion.div
            animate={{ rotate: 360 }}
            transition={{ duration: 2, repeat: Infinity, ease: "linear" }}
            className="bg-primary/10 p-8 rounded-3xl mx-auto w-fit mb-6"
          >
            <Sparkles className="text-primary" size={64} />
          </motion.div>
          <h2 className="text-xl font-semibold text-foreground mb-2">{t('ideal.generating')}</h2>
          <p className="text-sm text-muted-foreground">
            AI가 이상형을 생성하고 있습니다
          </p>
          <div className="mt-6 flex gap-2 justify-center">
            {[0, 1, 2].map((i) => (
              <motion.div
                key={i}
                animate={{ scale: [1, 1.2, 1] }}
                transition={{ duration: 1, repeat: Infinity, delay: i * 0.2 }}
                className="w-2 h-2 bg-primary rounded-full"
              />
            ))}
          </div>
        </motion.div>
      </div>
    );
  }

  return (
    <div className="pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
            <ArrowLeft size={24} className="text-foreground" />
          </button>
          <div>
            <h1 className="text-2xl font-semibold text-foreground">{t('ideal.result')}</h1>
          </div>
        </div>
        <button
          onClick={() => setStep('setup')}
          className="p-2 hover:bg-secondary rounded-xl transition-colors"
        >
          <RefreshCw size={20} className="text-foreground" />
        </button>
      </div>

      {/* Generated Images */}
      <div className="px-5 mb-6">
        <div className="grid grid-cols-2 gap-3">
          {generatedImages.map((img, idx) => (
            <motion.div
              key={idx}
              initial={{ opacity: 0, scale: 0.9 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: idx * 0.1 }}
              className="aspect-[3/4] rounded-2xl overflow-hidden shadow-lg"
            >
              <ImageWithFallback
                src={img}
                alt={`Generated ideal type ${idx + 1}`}
                className="w-full h-full object-cover"
              />
            </motion.div>
          ))}
        </div>
      </div>

      {/* Profile Text */}
      <div className="px-5 mb-6">
        <div className="bg-card rounded-2xl p-5 shadow-sm border border-border">
          <h3 className="font-semibold text-foreground mb-4">이상형 프로필</h3>
          <div className="space-y-3">
            {[
              { label: '성향', value: '따뜻하고 배려심 있는 성격' },
              { label: '대화 스타일', value: '진솔하고 공감을 잘하는 편' },
              { label: '추천 데이트', value: '조용한 카페나 공원 산책' },
              { label: '궁합 포인트', value: '서로를 존중하고 이해하는 관계' },
            ].map((item, idx) => (
              <div key={idx} className="flex gap-3">
                <div className="text-sm font-medium text-muted-foreground min-w-[80px]">
                  {item.label}
                </div>
                <div className="text-sm text-foreground">{item.value}</div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Actions */}
      <div className="px-5 mb-6 space-y-3">
        <button
          onClick={() => setStep('setup')}
          className="w-full py-3 bg-card border border-border rounded-xl font-medium hover:bg-secondary transition-colors flex items-center justify-center gap-2"
        >
          <RefreshCw size={18} />
          {t('ideal.regenerate')}
        </button>
        <div className="flex gap-3">
          <button className="flex-1 py-3 bg-card border border-border rounded-xl font-medium hover:bg-secondary transition-colors">
            {t('common.save')}
          </button>
          <button className="flex-1 py-3 bg-primary text-primary-foreground rounded-xl font-medium hover:bg-primary/90 transition-colors">
            {t('common.share')}
          </button>
        </div>
      </div>

      {/* Info */}
      <div className="px-5 pb-4">
        <p className="text-xs text-muted-foreground text-center">
          생성된 이미지는 AI로 만들어진 가상의 인물이며, 실존 인물과 무관합니다.
        </p>
      </div>
    </div>
  );
};
