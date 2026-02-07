import React from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { ArrowLeft, Sparkles, Heart, DollarSign, Activity, TrendingUp } from 'lucide-react';
import { motion } from 'motion/react';

interface FortuneDetailProps {
  onBack: () => void;
  data?: any;
}

export const FortuneDetail: React.FC<FortuneDetailProps> = ({ onBack, data }) => {
  const { t } = useApp();

  const item = data?.item;
  const payload = item?.payload || {};

  return (
    <div className="pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4 flex items-center gap-3">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
          <ArrowLeft size={24} className="text-foreground" />
        </button>
        <div className="flex-1">
          <h1 className="text-2xl font-semibold text-foreground">{item?.title || '운세 상세'}</h1>
          <p className="text-sm text-muted-foreground">{item?.dateLabel}</p>
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
            <div className="text-6xl font-bold text-white">{item?.score || 85}</div>
            <div className="text-white/90 text-sm pb-3">/ 100</div>
          </div>

          {payload.message && (
            <div className="bg-white/10 rounded-2xl p-4 backdrop-blur-sm">
              <div className="text-white/90 text-sm mb-2">오늘의 한마디</div>
              <div className="text-white text-base leading-relaxed">
                {payload.message}
              </div>
            </div>
          )}
        </motion.div>
      </div>

      {/* Detail Sections */}
      {payload.details && (
        <div className="px-5 mb-6 space-y-4">
          {payload.details.map((section: any, idx: number) => {
            const iconMap: any = {
              love: Heart,
              money: DollarSign,
              health: Activity,
              work: TrendingUp,
            };
            const Icon = iconMap[section.type] || Sparkles;
            
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
                    <div className={`${section.color || 'bg-primary'} p-3 rounded-xl`}>
                      <Icon className="text-white" size={20} />
                    </div>
                    <div>
                      <h3 className="font-semibold text-foreground">{section.title}</h3>
                      <div className="text-2xl font-bold text-primary mt-1">{section.score}</div>
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
      )}

      {/* Lucky Items */}
      {payload.luckyItems && (
        <div className="px-5 mb-6">
          <h3 className="font-semibold text-foreground mb-3">행운 아이템</h3>
          <div className="grid grid-cols-3 gap-3">
            {payload.luckyItems.map((item: any, idx: number) => (
              <div key={idx} className="bg-card rounded-2xl p-4 shadow-sm border border-border text-center">
                <div className="text-2xl mb-2">{item.icon}</div>
                <div className="text-xs text-muted-foreground mb-1">{item.label}</div>
                <div className="font-semibold text-foreground text-sm">{item.value}</div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Summary or default message */}
      {item?.summary && (
        <div className="px-5 mb-6">
          <div className="bg-gradient-to-br from-primary/10 to-transparent rounded-2xl p-5 border border-primary/20">
            <p className="text-sm text-foreground leading-relaxed">
              {item.summary}
            </p>
          </div>
        </div>
      )}

      {/* Disclaimer */}
      <div className="px-5 pb-4">
        <p className="text-xs text-muted-foreground text-center">
          {t('common.entertainment')}
        </p>
      </div>
    </div>
  );
};
