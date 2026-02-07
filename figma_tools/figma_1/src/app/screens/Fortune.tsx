import React from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { OracleCard } from '@/app/components/OracleCard';
import { Sparkles, Calendar, TrendingUp, Shuffle, Moon, ChevronRight } from 'lucide-react';
import { motion } from 'motion/react';

interface FortuneProps {
  onNavigate: (screen: string, data?: any) => void;
}

export const Fortune: React.FC<FortuneProps> = ({ onNavigate }) => {
  const { t } = useApp();

  return (
    <div className="pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4">
        <h1 className="text-2xl font-semibold text-foreground mb-1">{t('nav.fortune')}</h1>
        <p className="text-sm text-muted-foreground">오늘의 운세부터 사주분석까지</p>
      </div>

      {/* Category Tabs */}
      <div className="px-5 mb-6 overflow-x-auto">
        <div className="flex gap-2 pb-2">
          {['전체', '오늘', '만세력', '타로', '꿈해몽'].map((category, idx) => (
            <button
              key={idx}
              className={`px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-colors ${
                idx === 0
                  ? 'bg-primary text-primary-foreground'
                  : 'bg-secondary text-secondary-foreground hover:bg-primary/10'
              }`}
            >
              {category}
            </button>
          ))}
        </div>
      </div>

      {/* Today's Fortune */}
      <div className="px-5 mb-6">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          onClick={() => onNavigate('fortune-today')}
          className="bg-gradient-to-br from-[#8B6F47] to-[#C4A574] rounded-3xl p-6 shadow-lg cursor-pointer hover:shadow-xl transition-shadow"
        >
          <div className="flex items-center justify-between mb-4">
            <div>
              <div className="text-white/90 text-sm mb-1">2026년 1월 29일</div>
              <div className="text-white text-xl font-semibold">{t('fortune.today')}</div>
            </div>
            <div className="bg-white/20 p-3 rounded-xl backdrop-blur-sm">
              <Sparkles className="text-white" size={24} />
            </div>
          </div>
          
          <div className="bg-white/10 rounded-2xl p-4 backdrop-blur-sm mb-4">
            <div className="text-white/80 text-sm mb-2">오늘의 한마디</div>
            <div className="text-white text-base leading-relaxed">
              새로운 시작을 위한 준비가 필요한 날입니다. 작은 변화가 큰 결과를 가져올 수 있습니다.
            </div>
          </div>

          <div className="grid grid-cols-3 gap-2">
            {[
              { label: '애정운', value: 85, color: 'bg-[#E9C5B5]' },
              { label: '재물운', value: 72, color: 'bg-[#C4A574]' },
              { label: '건강운', value: 68, color: 'bg-[#9DB4A0]' },
            ].map((item, idx) => (
              <div key={idx} className="bg-white/10 rounded-xl p-3 backdrop-blur-sm text-center">
                <div className="text-white/80 text-xs mb-1">{item.label}</div>
                <div className="text-white text-lg font-bold">{item.value}</div>
              </div>
            ))}
          </div>
        </motion.div>
      </div>

      {/* Calendar / Manseryeok */}
      <div className="px-5 mb-6">
        <h2 className="font-semibold text-foreground mb-3">만세력 · 운세 달력</h2>
        <OracleCard
          title="만세력"
          description="일/월/년 운세를 한눈에 확인하세요"
          icon={<Calendar className="text-white" size={20} />}
          accentColor="bg-[#9DB4A0]"
          onClick={() => onNavigate('calendar')}
        >
          <div className="mt-4 p-4 bg-secondary rounded-xl">
            <div className="text-sm text-muted-foreground mb-2">이번 주 운세</div>
            <div className="flex gap-2">
              {['월', '화', '수', '목', '금'].map((day, idx) => (
                <div key={idx} className="flex-1 text-center">
                  <div className="text-xs text-muted-foreground mb-1">{day}</div>
                  <div className={`w-full h-1.5 rounded-full ${
                    idx === 2 ? 'bg-primary' : 'bg-primary/30'
                  }`} />
                </div>
              ))}
            </div>
          </div>
        </OracleCard>
      </div>

      {/* Saju Analysis */}
      <div className="px-5 mb-6">
        <h2 className="font-semibold text-foreground mb-3">사주 분석</h2>
        <OracleCard
          title="내 사주 상세 분석"
          description="오행, 십성, 대운 등 자세한 분석"
          icon={<TrendingUp className="text-white" size={20} />}
          accentColor="bg-primary"
          onClick={() => onNavigate('saju-analysis')}
        >
          <div className="mt-4 flex gap-2">
            <div className="flex-1 p-3 bg-secondary rounded-xl text-center">
              <div className="text-xs text-muted-foreground mb-1">오행</div>
              <div className="text-sm font-semibold text-foreground">목(木)</div>
            </div>
            <div className="flex-1 p-3 bg-secondary rounded-xl text-center">
              <div className="text-xs text-muted-foreground mb-1">십성</div>
              <div className="text-sm font-semibold text-foreground">편관</div>
            </div>
            <div className="flex-1 p-3 bg-secondary rounded-xl text-center">
              <div className="text-xs text-muted-foreground mb-1">대운</div>
              <div className="text-sm font-semibold text-foreground">길운</div>
            </div>
          </div>
        </OracleCard>
      </div>

      {/* Tarot */}
      <div className="px-5 mb-6">
        <h2 className="font-semibold text-foreground mb-3">{t('fortune.tarot')}</h2>
        <OracleCard
          title="타로 카드"
          description="오늘의 운세를 타로로 확인하세요"
          icon={<Shuffle className="text-white" size={20} />}
          accentColor="bg-[#B8D4E8]"
          onClick={() => onNavigate('tarot')}
        >
          <div className="mt-4 flex gap-2">
            {[1, 2, 3].map((num) => (
              <div
                key={num}
                className="flex-1 aspect-[2/3] bg-gradient-to-br from-primary/20 to-primary/5 rounded-xl border-2 border-primary/30 flex items-center justify-center"
              >
                <Shuffle className="text-primary/50" size={24} />
              </div>
            ))}
          </div>
        </OracleCard>
      </div>

      {/* Dream Interpretation */}
      <div className="px-5 mb-6">
        <h2 className="font-semibold text-foreground mb-3">{t('fortune.dream')}</h2>
        <OracleCard
          title="꿈해몽"
          description="꿈의 의미를 해석해드립니다"
          icon={<Moon className="text-white" size={20} />}
          accentColor="bg-[#C4A574]"
          onClick={() => onNavigate('dream')}
        />
      </div>
    </div>
  );
};
