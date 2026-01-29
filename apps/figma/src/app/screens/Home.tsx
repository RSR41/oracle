import React from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { OracleCard } from '@/app/components/OracleCard';
import { 
  Sparkles, 
  Heart, 
  Shuffle, 
  Moon, 
  Scan,
  MessageCircle,
  TrendingUp,
  Calendar,
  Users
} from 'lucide-react';
import { motion } from 'motion/react';

interface HomeProps {
  onNavigate: (screen: string, data?: any) => void;
}

export const Home: React.FC<HomeProps> = ({ onNavigate }) => {
  const { t } = useApp();

  return (
    <div className="pb-20">
      {/* Header */}
      <div className="bg-gradient-to-b from-primary/5 to-transparent px-5 pt-6 pb-8">
        <h1 className="text-3xl font-semibold text-foreground mb-2">{t('home.title')}</h1>
        <p className="text-sm text-muted-foreground">2026년 1월 29일</p>
      </div>

      {/* Today's Fortune Summary */}
      <div className="px-5 -mt-4 mb-6">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-gradient-to-br from-[#8B6F47] to-[#C4A574] rounded-3xl p-6 shadow-lg"
        >
          <div className="flex items-center justify-between mb-4">
            <span className="text-white/90 text-sm font-medium">{t('home.todayFortune')}</span>
            <Sparkles className="text-white" size={20} />
          </div>
          <div className="flex items-end gap-4 mb-4">
            <div className="text-5xl font-bold text-white">85</div>
            <div className="text-white/90 text-sm pb-2">{t('home.todayScore')}</div>
          </div>
          <div className="flex gap-2">
            {['연애', '재물', '건강'].map((item, idx) => (
              <div key={idx} className="flex-1 bg-white/20 rounded-xl p-2.5 backdrop-blur-sm">
                <div className="text-white/80 text-xs mb-1">{item}</div>
                <div className="text-white font-semibold text-sm">
                  {['좋음', '보통', '주의'][idx]}
                </div>
              </div>
            ))}
          </div>
          <button
            onClick={() => onNavigate('fortune-today')}
            className="w-full mt-4 bg-white/20 hover:bg-white/30 backdrop-blur-sm text-white py-2.5 rounded-xl text-sm font-medium transition-colors"
          >
            {t('home.viewDetail')} →
          </button>
        </motion.div>
      </div>

      {/* Quick Access */}
      <div className="px-5 mb-6">
        <div className="grid grid-cols-4 gap-3">
          {[
            { icon: Calendar, label: '만세력', screen: 'calendar', color: 'bg-[#9DB4A0]' },
            { icon: Heart, label: t('home.compatibility'), screen: 'compatibility', color: 'bg-[#E9C5B5]' },
            { icon: Shuffle, label: t('home.tarot'), screen: 'tarot', color: 'bg-[#B8D4E8]' },
            { icon: Moon, label: t('home.dream'), screen: 'dream', color: 'bg-[#C4A574]' },
          ].map((item, idx) => (
            <motion.button
              key={idx}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: idx * 0.05 }}
              onClick={() => onNavigate(item.screen)}
              className="bg-card rounded-2xl p-4 shadow-sm border border-border hover:shadow-md transition-all"
            >
              <div className={`${item.color} p-3 rounded-xl mx-auto w-fit mb-2`}>
                <item.icon className="text-white" size={20} />
              </div>
              <div className="text-xs text-foreground font-medium">{item.label}</div>
            </motion.button>
          ))}
        </div>
      </div>

      {/* Today's Connection (Hidden Social Feature) */}
      <div className="px-5 mb-6">
        <OracleCard
          title={t('home.todayConnection')}
          description={t('home.connectionDesc')}
          icon={<Users className="text-white" size={20} />}
          badge="Beta"
          accentColor="bg-[#9DB4A0]"
          onClick={() => onNavigate('connection')}
        />
      </div>

      {/* Consultation Section */}
      <div className="px-5 mb-6">
        <div className="flex items-center justify-between mb-3">
          <h2 className="font-semibold text-foreground">{t('home.consultation')}</h2>
        </div>
        <OracleCard
          title="전문 상담사와 대화하기"
          description={t('home.consultationDesc')}
          icon={<MessageCircle className="text-white" size={20} />}
          accentColor="bg-primary"
          onClick={() => onNavigate('consultation')}
        />
      </div>

      {/* Featured Services */}
      <div className="px-5 mb-6">
        <h2 className="font-semibold text-foreground mb-3">{t('home.recommended')}</h2>
        <div className="space-y-3">
          <OracleCard
            title="관상 분석"
            description="AI로 내 관상을 분석하고 이상형을 생성해보세요"
            icon={<Scan className="text-white" size={20} />}
            accentColor="bg-[#E9C5B5]"
            onClick={() => onNavigate('face')}
          />
          <OracleCard
            title="2026년 신년운세"
            description="새해의 운세를 미리 확인하세요"
            icon={<TrendingUp className="text-white" size={20} />}
            badge={t('common.new')}
            accentColor="bg-[#B8D4E8]"
            onClick={() => onNavigate('yearly-fortune')}
          />
        </div>
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
