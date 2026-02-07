import React from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { createHistoryItem } from '@/app/models/history';
import { ArrowLeft, Heart, TrendingUp, MessageCircle, AlertTriangle, Sparkles } from 'lucide-react';
import { motion } from 'motion/react';
import { toast } from 'sonner';

interface CompatResultProps {
  onBack: () => void;
  data?: {
    type: 'love' | 'friend' | 'business';
    partner: any;
    score: number;
  };
}

export const CompatResult: React.FC<CompatResultProps> = ({ onBack, data }) => {
  const { t, addHistoryItem } = useApp();
  
  const compatType = data?.type || 'love';
  const partnerName = data?.partner?.name || '상대방';
  const score = data?.score || 85;

  const typeLabels = {
    love: '연애 궁합',
    friend: '친구 궁합',
    business: '비즈니스 궁합',
  };

  const typeColors = {
    love: 'from-[#E9C5B5] to-[#C4A574]',
    friend: 'from-[#9DB4A0] to-[#C4A574]',
    business: 'from-[#B8D4E8] to-[#9DB4A0]',
  };

  const detailScores = {
    love: [
      { label: '애정', score: score - 5, icon: '💕' },
      { label: '대화', score: score + 3, icon: '💬' },
      { label: '가치관', score: score - 2, icon: '🤝' },
      { label: '성격', score: score + 5, icon: '✨' },
    ],
    friend: [
      { label: '친밀도', score: score + 2, icon: '🤝' },
      { label: '취미', score: score - 3, icon: '🎯' },
      { label: '신뢰', score: score + 5, icon: '💙' },
      { label: '공감', score: score - 1, icon: '😊' },
    ],
    business: [
      { label: '협업', score: score + 3, icon: '🤝' },
      { label: '목표', score: score - 2, icon: '🎯' },
      { label: '신뢰', score: score + 5, icon: '💼' },
      { label: '의사소통', score: score - 1, icon: '📊' },
    ],
  };

  const getScoreLevel = (score: number) => {
    if (score >= 90) return { label: '최상', color: 'text-green-500', desc: '매우 좋은 궁합입니다' };
    if (score >= 80) return { label: '상', color: 'text-[#C4A574]', desc: '좋은 궁합입니다' };
    if (score >= 70) return { label: '중', color: 'text-yellow-500', desc: '보통 궁합입니다' };
    return { label: '하', color: 'text-orange-500', desc: '노력이 필요합니다' };
  };

  const scoreLevel = getScoreLevel(score);

  const compatibilityAdvice = {
    love: {
      good: '서로에 대한 이해도가 높고, 감정적으로 잘 맞는 관계입니다. 진솔한 대화를 통해 더욱 깊은 관계로 발전할 수 있습니다.',
      attention: '가끔 의견 차이가 있을 수 있지만, 서로를 존중하고 배려한다면 좋은 관계를 유지할 수 있습니다.',
      tip: '정기적인 데이트와 깊은 대화 시간을 가지세요. 작은 선물과 배려가 관계를 더욱 돈독하게 만듭니다.',
    },
    friend: {
      good: '서로의 장점을 존중하고 이해하는 좋은 친구 관계를 형성할 수 있습니다. 함께 시간을 보낼수록 더 깊은 우정이 쌓일 것입니다.',
      attention: '때로는 의견이 다를 수 있지만, 이는 서로를 성장시키는 좋은 기회가 됩니다.',
      tip: '공통 관심사를 찾아 함께 활동해보세요. 서로의 차이를 인정하고 존중하는 것이 중요합니다.',
    },
    business: {
      good: '업무적으로 서로 보완하는 관계입니다. 목표를 향해 협력한다면 좋은 성과를 낼 수 있습니다.',
      attention: '업무 방식의 차이가 있을 수 있으니, 명확한 의사소통이 중요합니다.',
      tip: '정기적인 미팅과 피드백을 통해 서로의 의견을 조율하세요. 역할 분담을 명확히 하는 것이 좋습니다.',
    },
  };

  const advice = compatibilityAdvice[compatType];

  return (
    <div className="pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4 flex items-center gap-3">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
          <ArrowLeft size={24} className="text-foreground" />
        </button>
        <div>
          <h1 className="text-2xl font-semibold text-foreground">궁합 결과</h1>
          <p className="text-sm text-muted-foreground">{typeLabels[compatType]}</p>
        </div>
      </div>

      {/* Score Card */}
      <div className="px-5 mb-6">
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          className={`bg-gradient-to-br ${typeColors[compatType]} rounded-3xl p-6 shadow-lg`}
        >
          <div className="flex items-center justify-between mb-4">
            <div>
              <div className="text-white/90 text-sm mb-1">{partnerName}님과의</div>
              <div className="text-white text-xl font-semibold">{typeLabels[compatType]}</div>
            </div>
            <div className="bg-white/20 p-3 rounded-xl backdrop-blur-sm">
              <Heart className="text-white" size={24} />
            </div>
          </div>

          <div className="flex items-end gap-4 mb-4">
            <div className="text-6xl font-bold text-white">{score}</div>
            <div className="text-white/90 text-sm pb-3">/ 100</div>
          </div>

          <div className="bg-white/10 rounded-2xl p-4 backdrop-blur-sm">
            <div className="text-white/90 text-sm mb-1">궁합 등급</div>
            <div className={`text-white text-2xl font-bold`}>{scoreLevel.label}</div>
            <div className="text-white/80 text-sm mt-1">{scoreLevel.desc}</div>
          </div>
        </motion.div>
      </div>

      {/* Detail Scores */}
      <div className="px-5 mb-6">
        <h3 className="font-semibold text-foreground mb-3">세부 점수</h3>
        <div className="grid grid-cols-2 gap-3">
          {detailScores[compatType].map((item, idx) => (
            <motion.div
              key={idx}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: idx * 0.05 }}
              className="bg-card rounded-2xl p-4 shadow-sm border border-border"
            >
              <div className="flex items-center gap-2 mb-2">
                <span className="text-xl">{item.icon}</span>
                <div className="text-sm font-medium text-foreground">{item.label}</div>
              </div>
              <div className="text-2xl font-bold text-primary">{item.score}</div>
              <div className="w-full bg-secondary rounded-full h-1.5 mt-2">
                <div
                  className="bg-primary h-full rounded-full transition-all"
                  style={{ width: `${item.score}%` }}
                />
              </div>
            </motion.div>
          ))}
        </div>
      </div>

      {/* Analysis */}
      <div className="px-5 mb-6 space-y-4">
        <motion.div
          initial={{ opacity: 0, x: -20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ delay: 0.2 }}
          className="bg-card rounded-2xl p-5 shadow-sm border border-border"
        >
          <div className="flex items-start gap-3">
            <div className="bg-green-100 p-2 rounded-lg flex-shrink-0">
              <TrendingUp className="text-green-600" size={20} />
            </div>
            <div className="flex-1">
              <h4 className="font-semibold text-foreground mb-2">강점</h4>
              <p className="text-sm text-muted-foreground leading-relaxed">
                {advice.good}
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
            <div className="bg-orange-100 p-2 rounded-lg flex-shrink-0">
              <AlertTriangle className="text-orange-600" size={20} />
            </div>
            <div className="flex-1">
              <h4 className="font-semibold text-foreground mb-2">주의점</h4>
              <p className="text-sm text-muted-foreground leading-relaxed">
                {advice.attention}
              </p>
            </div>
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, x: -20 }}
          animate={{ opacity: 1, x: 0 }}
          transition={{ delay: 0.4 }}
          className="bg-card rounded-2xl p-5 shadow-sm border border-border"
        >
          <div className="flex items-start gap-3">
            <div className="bg-primary/10 p-2 rounded-lg flex-shrink-0">
              <Sparkles className="text-primary" size={20} />
            </div>
            <div className="flex-1">
              <h4 className="font-semibold text-foreground mb-2">조언</h4>
              <p className="text-sm text-muted-foreground leading-relaxed">
                {advice.tip}
              </p>
            </div>
          </div>
        </motion.div>
      </div>

      {/* Element Compatibility */}
      <div className="px-5 mb-6">
        <div className="bg-gradient-to-br from-primary/10 to-transparent rounded-2xl p-5 border border-primary/20">
          <h4 className="font-semibold text-foreground mb-3">오행 궁합</h4>
          <div className="grid grid-cols-2 gap-3 mb-3">
            <div className="text-center">
              <div className="text-xs text-muted-foreground mb-1">나</div>
              <div className="text-lg font-semibold text-foreground">목(木)</div>
            </div>
            <div className="text-center">
              <div className="text-xs text-muted-foreground mb-1">{partnerName}님</div>
              <div className="text-lg font-semibold text-foreground">수(水)</div>
            </div>
          </div>
          <p className="text-sm text-muted-foreground text-center">
            수생목 - 서로를 보완하는 좋은 조합입니다
          </p>
        </div>
      </div>

      {/* Actions */}
      <div className="px-5 mb-6 flex gap-3">
        <button
          className="flex-1 py-3 bg-card border border-border rounded-xl font-medium hover:bg-secondary transition-colors"
          onClick={() => {
            const historyItem = createHistoryItem(
              'compat',
              `${partnerName}님과의 ${typeLabels[compatType]}`,
              {
                type: compatType,
                partner: data?.partner,
                score,
                detailScores: detailScores[compatType],
                advice: advice,
              },
              score,
              scoreLevel.desc
            );
            addHistoryItem(historyItem);
            toast.success('궁합 결과가 저장되었습니다!');
          }}
        >
          {t('common.save')}
        </button>
        <button className="flex-1 py-3 bg-primary text-primary-foreground rounded-xl font-medium hover:bg-primary/90 transition-colors">
          {t('common.share')}
        </button>
      </div>

      {/* Disclaimer */}
      <div className="px-5 pb-4">
        <p className="text-xs text-muted-foreground text-center">
          {t('common.entertainment')}
        </p>
      </div>
    </div>
  );
};