import React from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { createHistoryItem } from '@/app/models/history';
import { ArrowLeft, Sparkles, TrendingUp, TrendingDown, Heart, DollarSign, Activity } from 'lucide-react';
import { motion } from 'motion/react';
import { toast } from 'sonner';

interface FortuneTodayProps {
  onBack: () => void;
}

export const FortuneToday: React.FC<FortuneTodayProps> = ({ onBack }) => {
  const { t, addHistoryItem } = useApp();

  const fortuneData = {
    overall: 85,
    love: 92,
    money: 78,
    health: 85,
    work: 88,
    study: 75,
    message: '새로운 시작을 위한 준비가 필요한 날입니다. 작은 변화가 큰 결과를 가져올 수 있습니다.',
    luckyColor: '#C4A574',
    luckyNumber: 7,
    luckyTime: '오후 2-4시',
  };

  const detailSections = [
    {
      icon: Heart,
      title: '애정운',
      score: fortuneData.love,
      color: 'bg-[#E9C5B5]',
      trend: 'up',
      content: '오늘은 사랑하는 사람과의 관계가 더욱 깊어질 수 있는 날입니다. 진솔한 대화를 나눠보세요.',
    },
    {
      icon: DollarSign,
      title: '재물운',
      score: fortuneData.money,
      color: 'bg-[#C4A574]',
      trend: 'stable',
      content: '예상치 못한 작은 수입이 있을 수 있습니다. 하지만 충동구매는 피하는 것이 좋습니다.',
    },
    {
      icon: Activity,
      title: '건강운',
      score: fortuneData.health,
      color: 'bg-[#9DB4A0]',
      trend: 'up',
      content: '몸 상태가 좋은 날입니다. 가벼운 운동이나 산책을 하면 더욱 좋습니다.',
    },
    {
      icon: TrendingUp,
      title: '직장/학업운',
      score: fortuneData.work,
      color: 'bg-[#B8D4E8]',
      trend: 'up',
      content: '집중력이 높아지는 시기입니다. 중요한 프로젝트나 시험 준비에 좋은 날입니다.',
    },
  ];

  const handleSave = () => {
    const historyItem = createHistoryItem(
      'fortune',
      '오늘의 운세',
      {
        ...fortuneData,
        details: detailSections.map(s => ({
          type: s.title === '애정운' ? 'love' : s.title === '재물운' ? 'money' : s.title === '건강운' ? 'health' : 'work',
          title: s.title,
          score: s.score,
          color: s.color,
          content: s.content,
        })),
        luckyItems: [
          { icon: '🎨', label: '행운의 색', value: '골드' },
          { icon: '🔢', label: '행운의 숫자', value: fortuneData.luckyNumber.toString() },
          { icon: '⏰', label: '행운의 시간', value: fortuneData.luckyTime },
        ],
      },
      fortuneData.overall,
      fortuneData.message
    );
    
    addHistoryItem(historyItem);
    toast.success('운세가 저장되었습니다!');
  };

  return (
    <div className="pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4 flex items-center gap-3">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
          <ArrowLeft size={24} className="text-foreground" />
        </button>
        <div>
          <h1 className="text-2xl font-semibold text-foreground">오늘의 운세</h1>
          <p className="text-sm text-muted-foreground">2026년 1월 30일 (금요일)</p>
        </div>
      </div>

      {/* Overall Score */}
      <div className="px-5 mb-6">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-gradient-to-br from-[#8B6F47] to-[#C4A574] rounded-3xl p-6 shadow-lg"
        >
          <div className="flex items-center justify-between mb-4">
            <span className="text-white text-lg font-semibold">종합 운세</span>
            <div className="bg-white/20 p-2.5 rounded-xl backdrop-blur-sm">
              <Sparkles className="text-white" size={20} />
            </div>
          </div>
          
          <div className="flex items-end gap-4 mb-4">
            <div className="text-6xl font-bold text-white">{fortuneData.overall}</div>
            <div className="text-white/90 text-sm pb-3">/ 100</div>
          </div>

          <div className="bg-white/10 rounded-2xl p-4 backdrop-blur-sm">
            <div className="text-white/90 text-sm mb-2">오늘의 한마디</div>
            <div className="text-white text-base leading-relaxed">
              {fortuneData.message}
            </div>
          </div>
        </motion.div>
      </div>

      {/* Detailed Fortune */}
      <div className="px-5 mb-6 space-y-4">
        {detailSections.map((section, idx) => {
          const Icon = section.icon;
          const TrendIcon = section.trend === 'up' ? TrendingUp : section.trend === 'down' ? TrendingDown : Activity;
          
          return (
            <motion.div
              key={idx}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: idx * 0.1 }}
              className="bg-card rounded-2xl p-5 shadow-sm border border-border"
            >
              <div className="flex items-start justify-between mb-3">
                <div className="flex items-center gap-3">
                  <div className={`${section.color} p-3 rounded-xl`}>
                    <Icon className="text-white" size={20} />
                  </div>
                  <div>
                    <h3 className="font-semibold text-foreground">{section.title}</h3>
                    <div className="flex items-center gap-2 mt-1">
                      <div className="text-2xl font-bold text-primary">{section.score}</div>
                      <TrendIcon 
                        size={16} 
                        className={section.trend === 'up' ? 'text-green-500' : section.trend === 'down' ? 'text-red-500' : 'text-muted-foreground'} 
                      />
                    </div>
                  </div>
                </div>
              </div>
              <p className="text-sm text-muted-foreground leading-relaxed">
                {section.content}
              </p>
            </motion.div>
          );
        })}
      </div>

      {/* Lucky Items */}
      <div className="px-5 mb-6">
        <h3 className="font-semibold text-foreground mb-3">행운 아이템</h3>
        <div className="grid grid-cols-3 gap-3">
          <div className="bg-card rounded-2xl p-4 shadow-sm border border-border text-center">
            <div className="text-2xl mb-2">🎨</div>
            <div className="text-xs text-muted-foreground mb-1">행운의 색</div>
            <div className="font-semibold text-foreground text-sm">골드</div>
          </div>
          <div className="bg-card rounded-2xl p-4 shadow-sm border border-border text-center">
            <div className="text-2xl mb-2">🔢</div>
            <div className="text-xs text-muted-foreground mb-1">행운의 숫자</div>
            <div className="font-semibold text-foreground text-sm">{fortuneData.luckyNumber}</div>
          </div>
          <div className="bg-card rounded-2xl p-4 shadow-sm border border-border text-center">
            <div className="text-2xl mb-2">⏰</div>
            <div className="text-xs text-muted-foreground mb-1">행운의 시간</div>
            <div className="font-semibold text-foreground text-xs">{fortuneData.luckyTime}</div>
          </div>
        </div>
      </div>

      {/* Advice */}
      <div className="px-5 mb-6">
        <div className="bg-gradient-to-br from-primary/10 to-transparent rounded-2xl p-5 border border-primary/20">
          <div className="flex items-start gap-3">
            <Sparkles className="text-primary flex-shrink-0" size={20} />
            <div>
              <h3 className="font-semibold text-foreground mb-2">오늘의 조언</h3>
              <p className="text-sm text-foreground leading-relaxed">
                긍정적인 마음가짐으로 하루를 시작하세요. 작은 친절이 큰 행운을 불러올 수 있습니다. 
                주변 사람들에게 먼저 웃음을 건네보세요.
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* Actions */}
      <div className="px-5 mb-6 flex gap-3">
        <button onClick={handleSave} className="flex-1 py-3 bg-card border border-border rounded-xl font-medium hover:bg-secondary transition-colors">
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