import React from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { ArrowLeft, Heart, Users, Briefcase, Star } from 'lucide-react';
import { motion } from 'motion/react';

interface CompatDetailProps {
  onBack: () => void;
  data?: any;
}

export const CompatDetail: React.FC<CompatDetailProps> = ({ onBack, data }) => {
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
          <h1 className="text-2xl font-semibold text-foreground">{item?.title || '궁합 상세'}</h1>
          <p className="text-sm text-muted-foreground">{item?.dateLabel}</p>
        </div>
      </div>

      {/* Overall Score */}
      <div className="px-5 mb-6">
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          className="bg-gradient-to-br from-[#E9C5B5] to-[#C4A574] rounded-3xl p-6 shadow-lg text-center"
        >
          <div className="bg-white/20 p-3 rounded-full w-fit mx-auto mb-4 backdrop-blur-sm">
            <Heart className="text-white" size={32} />
          </div>
          
          <div className="text-white/90 text-sm mb-2">궁합 점수</div>
          <div className="text-6xl font-bold text-white mb-4">{item?.score || 92}</div>
          
          <div className="flex items-center justify-center gap-1 mb-4">
            {[...Array(5)].map((_, i) => (
              <Star
                key={i}
                size={20}
                className={i < Math.floor((item?.score || 92) / 20) ? 'text-white fill-white' : 'text-white/40'}
              />
            ))}
          </div>

          {payload.partner && (
            <div className="bg-white/10 rounded-2xl p-4 backdrop-blur-sm">
              <div className="text-white text-base">
                {payload.partner.name || '상대방'}님과의 궁합
              </div>
            </div>
          )}
        </motion.div>
      </div>

      {/* Categories */}
      {payload.categories && (
        <div className="px-5 mb-6 space-y-3">
          {payload.categories.map((cat: any, idx: number) => {
            const iconMap: any = {
              love: Heart,
              friend: Users,
              business: Briefcase,
            };
            const Icon = iconMap[cat.type] || Star;

            return (
              <motion.div
                key={idx}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: idx * 0.1 }}
                className="bg-card rounded-2xl p-5 shadow-sm border border-border"
              >
                <div className="flex items-center justify-between mb-3">
                  <div className="flex items-center gap-3">
                    <div className={`${cat.color || 'bg-[#E9C5B5]'} p-3 rounded-xl`}>
                      <Icon className="text-white" size={20} />
                    </div>
                    <h3 className="font-semibold text-foreground">{cat.title}</h3>
                  </div>
                  <div className="text-2xl font-bold text-primary">{cat.score}</div>
                </div>
                <p className="text-sm text-muted-foreground leading-relaxed">
                  {cat.description}
                </p>
              </motion.div>
            );
          })}
        </div>
      )}

      {/* Advice */}
      {payload.advice && (
        <div className="px-5 mb-6">
          <div className="bg-gradient-to-br from-primary/10 to-transparent rounded-2xl p-5 border border-primary/20">
            <h3 className="font-semibold text-foreground mb-3">관계 조언</h3>
            <p className="text-sm text-foreground leading-relaxed">
              {payload.advice}
            </p>
          </div>
        </div>
      )}

      {/* Summary */}
      {item?.summary && (
        <div className="px-5 mb-6">
          <div className="bg-card rounded-2xl p-5 shadow-sm border border-border">
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
