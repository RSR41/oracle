import React, { useState } from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { ArrowLeft, Shuffle, Sparkles } from 'lucide-react';
import { motion } from 'motion/react';

interface TarotProps {
  onBack: () => void;
}

export const Tarot: React.FC<TarotProps> = ({ onBack }) => {
  const { t } = useApp();
  const [step, setStep] = useState<'select' | 'draw' | 'result'>('select');
  const [spreadType, setSpreadType] = useState<1 | 3>(1);
  const [drawnCards, setDrawnCards] = useState<number[]>([]);

  const tarotCards = [
    { name: 'The Fool', meaning: '새로운 시작, 순수함, 모험' },
    { name: 'The Magician', meaning: '창조, 능력, 실행력' },
    { name: 'The High Priestess', meaning: '직관, 신비, 내면의 지혜' },
    { name: 'The Empress', meaning: '풍요, 모성, 창조성' },
    { name: 'The Lovers', meaning: '사랑, 선택, 조화' },
    { name: 'The Star', meaning: '희망, 영감, 치유' },
    { name: 'The Sun', meaning: '기쁨, 성공, 활력' },
  ];

  const handleDraw = () => {
    const cards = [];
    while (cards.length < spreadType) {
      const random = Math.floor(Math.random() * tarotCards.length);
      if (!cards.includes(random)) {
        cards.push(random);
      }
    }
    setDrawnCards(cards);
    setStep('result');
  };

  if (step === 'select') {
    return (
      <div className="min-h-screen pb-20">
        {/* Header */}
        <div className="px-5 pt-6 pb-4 flex items-center gap-3">
          <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
            <ArrowLeft size={24} className="text-foreground" />
          </button>
          <div>
            <h1 className="text-2xl font-semibold text-foreground">{t('fortune.tarot')}</h1>
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
                <h3 className="font-semibold text-foreground mb-2">타로 안내</h3>
                <ul className="text-sm text-muted-foreground space-y-1.5">
                  <li>• 마음을 편안하게 하고 질문을 생각하세요</li>
                  <li>• 카드를 섞으며 집중해주세요</li>
                  <li>• 하루에 한 번만 읽는 것을 권장합니다</li>
                </ul>
              </div>
            </div>
          </div>
        </div>

        {/* Spread Selection */}
        <div className="px-5 mb-6">
          <h3 className="font-semibold text-foreground mb-3">스프레드 선택</h3>
          <div className="grid grid-cols-2 gap-3">
            <button
              onClick={() => setSpreadType(1)}
              className={`p-6 rounded-2xl border-2 transition-all ${
                spreadType === 1
                  ? 'border-primary bg-primary/5'
                  : 'border-border bg-card hover:border-primary/50'
              }`}
            >
              <div className="text-4xl mb-3">🃏</div>
              <div className={`font-semibold mb-1 ${
                spreadType === 1 ? 'text-primary' : 'text-foreground'
              }`}>
                1장 타로
              </div>
              <div className="text-sm text-muted-foreground">
                오늘의 운세
              </div>
            </button>

            <button
              onClick={() => setSpreadType(3)}
              className={`p-6 rounded-2xl border-2 transition-all ${
                spreadType === 3
                  ? 'border-primary bg-primary/5'
                  : 'border-border bg-card hover:border-primary/50'
              }`}
            >
              <div className="text-4xl mb-3">🃏🃏🃏</div>
              <div className={`font-semibold mb-1 ${
                spreadType === 3 ? 'text-primary' : 'text-foreground'
              }`}>
                3장 타로
              </div>
              <div className="text-sm text-muted-foreground">
                과거·현재·미래
              </div>
            </button>
          </div>
        </div>

        {/* Draw Button */}
        <div className="px-5">
          <button
            onClick={() => setStep('draw')}
            className="w-full bg-gradient-to-r from-[#B8D4E8] to-[#9DB4A0] text-white py-4 rounded-2xl font-semibold shadow-lg hover:shadow-xl transition-shadow"
          >
            <Shuffle className="inline mr-2" size={20} />
            카드 뽑기
          </button>
        </div>
      </div>
    );
  }

  if (step === 'draw') {
    return (
      <div className="min-h-screen pb-20">
        {/* Header */}
        <div className="px-5 pt-6 pb-4">
          <h1 className="text-2xl font-semibold text-foreground text-center">카드를 섞고 있습니다...</h1>
        </div>

        {/* Cards Animation */}
        <div className="px-5 py-20 flex items-center justify-center gap-4">
          {Array.from({ length: spreadType }).map((_, idx) => (
            <motion.div
              key={idx}
              animate={{ 
                rotateY: [0, 180, 360],
                y: [0, -20, 0]
              }}
              transition={{ 
                duration: 1,
                repeat: Infinity,
                delay: idx * 0.2 
              }}
              className="w-24 h-36 bg-gradient-to-br from-[#B8D4E8] to-[#9DB4A0] rounded-2xl shadow-xl flex items-center justify-center"
            >
              <Shuffle className="text-white" size={32} />
            </motion.div>
          ))}
        </div>

        <div className="px-5">
          <button
            onClick={handleDraw}
            className="w-full bg-primary text-primary-foreground py-4 rounded-2xl font-semibold hover:bg-primary/90 transition-colors"
          >
            카드 확인하기
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4 flex items-center gap-3">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
          <ArrowLeft size={24} className="text-foreground" />
        </button>
        <div>
          <h1 className="text-2xl font-semibold text-foreground">타로 결과</h1>
        </div>
      </div>

      {/* Cards Result */}
      <div className="px-5 mb-6">
        {spreadType === 3 && (
          <div className="flex gap-2 mb-4 text-sm text-muted-foreground">
            <div className="flex-1 text-center">과거</div>
            <div className="flex-1 text-center">현재</div>
            <div className="flex-1 text-center">미래</div>
          </div>
        )}
        
        <div className="flex gap-3 justify-center mb-6">
          {drawnCards.map((cardIdx, idx) => (
            <motion.div
              key={idx}
              initial={{ opacity: 0, rotateY: 180 }}
              animate={{ opacity: 1, rotateY: 0 }}
              transition={{ delay: idx * 0.2 }}
              className="w-28 h-40 bg-gradient-to-br from-[#B8D4E8] to-[#9DB4A0] rounded-2xl shadow-xl p-4 flex flex-col items-center justify-center text-center"
            >
              <div className="text-white text-sm font-semibold">
                {tarotCards[cardIdx].name}
              </div>
            </motion.div>
          ))}
        </div>
      </div>

      {/* Interpretation */}
      <div className="px-5 mb-6 space-y-4">
        {drawnCards.map((cardIdx, idx) => (
          <motion.div
            key={idx}
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: idx * 0.2 + 0.6 }}
            className="bg-card rounded-2xl p-5 shadow-sm border border-border"
          >
            <div className="flex items-start gap-3 mb-3">
              <span className="text-2xl">🔮</span>
              <div className="flex-1">
                <h3 className="font-semibold text-foreground mb-1">
                  {tarotCards[cardIdx].name}
                </h3>
                <p className="text-sm text-muted-foreground">
                  {tarotCards[cardIdx].meaning}
                </p>
              </div>
            </div>
            
            <div className="pl-11">
              <h4 className="text-sm font-semibold text-foreground mb-2">해석</h4>
              <p className="text-sm text-foreground leading-relaxed">
                이 카드는 {spreadType === 3 ? ['당신의 과거', '현재 상황', '다가올 미래'][idx] : '오늘의 운세'}를 나타냅니다. 
                긍정적인 에너지가 흐르고 있으니 자신감을 가지고 나아가세요.
              </p>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Overall Guidance */}
      <div className="px-5 mb-6">
        <div className="bg-gradient-to-br from-primary/10 to-transparent rounded-2xl p-5 border border-primary/20">
          <h3 className="font-semibold text-foreground mb-2">종합 조언</h3>
          <p className="text-sm text-foreground leading-relaxed">
            카드들이 전하는 메시지는 긍정적입니다. 
            자신을 믿고 한 걸음씩 나아가면 좋은 결과가 있을 것입니다.
          </p>
        </div>
      </div>

      {/* Actions */}
      <div className="px-5 mb-6 flex gap-3">
        <button className="flex-1 py-3 bg-card border border-border rounded-xl font-medium hover:bg-secondary transition-colors">
          {t('common.save')}
        </button>
        <button className="flex-1 py-3 bg-primary text-primary-foreground rounded-xl font-medium hover:bg-primary/90 transition-colors">
          {t('common.share')}
        </button>
      </div>
    </div>
  );
};
