import React, { useState } from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { ArrowLeft, Moon, Sparkles, Tag } from 'lucide-react';
import { motion } from 'motion/react';

interface DreamProps {
  onBack: () => void;
}

export const Dream: React.FC<DreamProps> = ({ onBack }) => {
  const { t } = useApp();
  const [step, setStep] = useState<'input' | 'analyzing' | 'result'>('input');
  const [dreamText, setDreamText] = useState('');
  const [selectedEmotion, setSelectedEmotion] = useState('');
  const [selectedTags, setSelectedTags] = useState<string[]>([]);

  const emotions = [
    { id: 'happy', label: '기쁨', emoji: '😊' },
    { id: 'scared', label: '두려움', emoji: '😨' },
    { id: 'excited', label: '설렘', emoji: '😍' },
    { id: 'anxious', label: '불안', emoji: '😰' },
    { id: 'peaceful', label: '평온', emoji: '😌' },
  ];

  const commonTags = [
    '물', '불', '사람', '동물', '집', '학교', '가족', '돈', 
    '차', '비행기', '산', '바다', '하늘', '싸움', '죽음', '결혼'
  ];

  const handleAnalyze = () => {
    setStep('analyzing');
    
    setTimeout(() => {
      setStep('result');
    }, 2000);
  };

  const toggleTag = (tag: string) => {
    if (selectedTags.includes(tag)) {
      setSelectedTags(selectedTags.filter(t => t !== tag));
    } else {
      setSelectedTags([...selectedTags, tag]);
    }
  };

  if (step === 'input') {
    return (
      <div className="min-h-screen pb-20">
        {/* Header */}
        <div className="px-5 pt-6 pb-4 flex items-center gap-3">
          <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
            <ArrowLeft size={24} className="text-foreground" />
          </button>
          <div>
            <h1 className="text-2xl font-semibold text-foreground">{t('fortune.dream')}</h1>
          </div>
        </div>

        {/* Info */}
        <div className="px-5 mb-6">
          <div className="bg-primary/5 border border-primary/20 rounded-2xl p-5">
            <div className="flex items-start gap-3">
              <div className="bg-primary/10 p-2 rounded-lg">
                <Moon className="text-primary" size={20} />
              </div>
              <div className="flex-1">
                <h3 className="font-semibold text-foreground mb-2">꿈해몽 안내</h3>
                <p className="text-sm text-muted-foreground">
                  꾼 꿈을 자세히 적어주시면 더 정확한 해몽이 가능합니다
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Dream Input */}
        <div className="px-5 mb-6">
          <h3 className="font-semibold text-foreground mb-3">꿈 내용</h3>
          <textarea
            value={dreamText}
            onChange={(e) => setDreamText(e.target.value)}
            placeholder="어떤 꿈을 꾸셨나요? 자세히 적어주세요..."
            className="w-full h-40 p-4 bg-card border border-border rounded-2xl resize-none focus:outline-none focus:ring-2 focus:ring-primary/20 text-foreground placeholder:text-muted-foreground"
          />
        </div>

        {/* Emotion Selection */}
        <div className="px-5 mb-6">
          <h3 className="font-semibold text-foreground mb-3">느낌</h3>
          <div className="flex flex-wrap gap-2">
            {emotions.map((emotion) => (
              <button
                key={emotion.id}
                onClick={() => setSelectedEmotion(emotion.id)}
                className={`px-4 py-2.5 rounded-full border-2 transition-all ${
                  selectedEmotion === emotion.id
                    ? 'border-primary bg-primary/5'
                    : 'border-border bg-card hover:border-primary/50'
                }`}
              >
                <span className="mr-2">{emotion.emoji}</span>
                <span className={`text-sm font-medium ${
                  selectedEmotion === emotion.id ? 'text-primary' : 'text-foreground'
                }`}>
                  {emotion.label}
                </span>
              </button>
            ))}
          </div>
        </div>

        {/* Tags */}
        <div className="px-5 mb-6">
          <div className="flex items-center gap-2 mb-3">
            <Tag size={18} className="text-foreground" />
            <h3 className="font-semibold text-foreground">주요 키워드</h3>
          </div>
          <div className="flex flex-wrap gap-2">
            {commonTags.map((tag) => (
              <button
                key={tag}
                onClick={() => toggleTag(tag)}
                className={`px-3 py-1.5 rounded-full text-sm transition-all ${
                  selectedTags.includes(tag)
                    ? 'bg-primary text-primary-foreground'
                    : 'bg-secondary text-secondary-foreground hover:bg-primary/10'
                }`}
              >
                {tag}
              </button>
            ))}
          </div>
        </div>

        {/* Analyze Button */}
        <div className="px-5">
          <button
            onClick={handleAnalyze}
            disabled={!dreamText.trim()}
            className="w-full bg-gradient-to-r from-[#C4A574] to-[#8B6F47] text-white py-4 rounded-2xl font-semibold shadow-lg hover:shadow-xl transition-shadow disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <Moon className="inline mr-2" size={20} />
            {t('fortune.interpretDream')}
          </button>
        </div>
      </div>
    );
  }

  if (step === 'analyzing') {
    return (
      <div className="min-h-screen flex items-center justify-center px-5 pb-20">
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          className="text-center"
        >
          <motion.div
            animate={{ rotate: [0, 10, -10, 0] }}
            transition={{ duration: 2, repeat: Infinity }}
            className="bg-primary/10 p-8 rounded-3xl mx-auto w-fit mb-6"
          >
            <Moon className="text-primary" size={64} />
          </motion.div>
          <h2 className="text-xl font-semibold text-foreground mb-2">꿈을 해석하고 있습니다...</h2>
          <p className="text-sm text-muted-foreground">
            AI가 꿈의 상징을 분석 중입니다
          </p>
        </motion.div>
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
          <h1 className="text-2xl font-semibold text-foreground">해몽 결과</h1>
        </div>
      </div>

      {/* Dream Summary */}
      <div className="px-5 mb-6">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-gradient-to-br from-[#C4A574] to-[#8B6F47] rounded-3xl p-6 shadow-lg"
        >
          <div className="flex items-center justify-between mb-4">
            <span className="text-white text-lg font-semibold">해몽 요약</span>
            <div className="bg-white/20 p-2.5 rounded-xl backdrop-blur-sm">
              <Moon className="text-white" size={20} />
            </div>
          </div>
          <div className="bg-white/10 rounded-2xl p-4 backdrop-blur-sm">
            <div className="text-white/90 text-sm mb-2">꿈의 성격</div>
            <div className="text-white text-xl font-bold">길몽 (吉夢)</div>
          </div>
        </motion.div>
      </div>

      {/* Interpretation Sections */}
      <div className="px-5 mb-6 space-y-4">
        <motion.div
          initial={{ opacity: 0, x: -20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ delay: 0.1 }}
          className="bg-card rounded-2xl p-5 shadow-sm border border-border"
        >
          <div className="flex items-start gap-3">
            <span className="text-2xl">🔮</span>
            <div className="flex-1">
              <h3 className="font-semibold text-foreground mb-2">상징</h3>
              <p className="text-sm text-muted-foreground leading-relaxed">
                {selectedTags.length > 0 
                  ? `${selectedTags.join(', ')}은(는) 새로운 기회와 변화를 상징합니다.`
                  : '꿈에 나타난 요소들은 긍정적인 변화를 암시합니다.'
                }
              </p>
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, x: -20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ delay: 0.2 }}
          className="bg-card rounded-2xl p-5 shadow-sm border border-border"
        >
          <div className="flex items-start gap-3">
            <span className="text-2xl">💭</span>
            <div className="flex-1">
              <h3 className="font-semibold text-foreground mb-2">심리 해석</h3>
              <p className="text-sm text-muted-foreground leading-relaxed">
                현재 긍정적인 마음 상태에 있으며, 새로운 도전을 준비하고 있는 것으로 보입니다.
                자신감을 가지고 나아가세요.
              </p>
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, x: -20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ delay: 0.3 }}
          className="bg-card rounded-2xl p-5 shadow-sm border border-border"
        >
          <div className="flex items-start gap-3">
            <span className="text-2xl">💡</span>
            <div className="flex-1">
              <h3 className="font-semibold text-foreground mb-2">조언</h3>
              <p className="text-sm text-muted-foreground leading-relaxed">
                좋은 기회가 찾아올 수 있으니 주변의 변화를 주의 깊게 살피세요.
                작은 기회도 놓치지 말고 적극적으로 행동하면 좋은 결과가 있을 것입니다.
              </p>
            </div>
          </div>
        </motion.div>
      </div>

      {/* Related Fortune */}
      <div className="px-5 mb-6">
        <div className="bg-gradient-to-br from-primary/10 to-transparent rounded-2xl p-5 border border-primary/20">
          <div className="flex items-start gap-3 mb-3">
            <Sparkles className="text-primary" size={20} />
            <div>
              <h3 className="font-semibold text-foreground mb-1">관련 운세</h3>
              <p className="text-sm text-foreground leading-relaxed">
                이번 주 재물운이 상승하는 시기입니다. 투자나 새로운 프로젝트를 시작하기 좋은 때입니다.
              </p>
            </div>
          </div>
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
