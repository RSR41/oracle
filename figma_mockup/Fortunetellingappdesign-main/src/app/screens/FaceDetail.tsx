import React from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { ArrowLeft, Scan, Sparkles, TrendingUp, Heart, Star } from 'lucide-react';
import { motion } from 'motion/react';

interface FaceDetailProps {
  onBack: () => void;
  data?: any;
}

export const FaceDetail: React.FC<FaceDetailProps> = ({ onBack, data }) => {
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
          <h1 className="text-2xl font-semibold text-foreground">{item?.title || '관상 분석'}</h1>
          <p className="text-sm text-muted-foreground">{item?.dateLabel}</p>
        </div>
      </div>

      {/* Score */}
      {item?.score && (
        <div className="px-5 mb-6">
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            className="bg-gradient-to-br from-[#E9C5B5] to-[#C4A574] rounded-2xl p-6 shadow-lg text-center"
          >
            <div className="bg-white/20 p-3 rounded-full w-fit mx-auto mb-4 backdrop-blur-sm">
              <Scan className="text-white" size={32} />
            </div>
            
            <div className="text-white/90 text-sm mb-2">관상 점수</div>
            <div className="text-6xl font-bold text-white">{item.score}</div>
          </motion.div>
        </div>
      )}

      {/* Features Analysis */}
      {payload.features && (
        <div className="px-5 mb-6 space-y-3">
          <h3 className="font-semibold text-foreground mb-3">얼굴 특징 분석</h3>
          {payload.features.map((feature: any, idx: number) => (
            <motion.div
              key={idx}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: idx * 0.1 }}
              className="bg-card rounded-2xl p-5 shadow-sm border border-border"
            >
              <div className="flex items-start justify-between mb-2">
                <h4 className="font-medium text-foreground">{feature.name}</h4>
                {feature.score && (
                  <span className="text-lg font-bold text-primary">{feature.score}</span>
                )}
              </div>
              <p className="text-sm text-muted-foreground leading-relaxed">
                {feature.analysis}
              </p>
            </motion.div>
          ))}
        </div>
      )}

      {/* Personality Traits */}
      {payload.personality && (
        <div className="px-5 mb-6">
          <h3 className="font-semibold text-foreground mb-3">성격 특성</h3>
          <div className="bg-card rounded-2xl p-5 shadow-sm border border-border">
            <div className="flex flex-wrap gap-2 mb-4">
              {payload.personality.traits?.map((trait: string, idx: number) => (
                <span
                  key={idx}
                  className="px-3 py-1.5 bg-primary/10 text-primary text-sm rounded-full"
                >
                  {trait}
                </span>
              ))}
            </div>
            {payload.personality.description && (
              <p className="text-sm text-foreground leading-relaxed">
                {payload.personality.description}
              </p>
            )}
          </div>
        </div>
      )}

      {/* Fortune Areas */}
      {payload.fortune && (
        <div className="px-5 mb-6">
          <h3 className="font-semibold text-foreground mb-3">운세 영역</h3>
          <div className="grid grid-cols-2 gap-3">
            {payload.fortune.map((area: any, idx: number) => {
              const iconMap: any = {
                love: Heart,
                career: TrendingUp,
                wealth: Sparkles,
                health: Star,
              };
              const Icon = iconMap[area.type] || Star;

              return (
                <motion.div
                  key={idx}
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ delay: idx * 0.1 }}
                  className="bg-card rounded-xl p-4 shadow-sm border border-border"
                >
                  <div className={`${area.color || 'bg-primary'} p-2 rounded-lg w-fit mb-3`}>
                    <Icon className="text-white" size={20} />
                  </div>
                  <div className="text-xs text-muted-foreground mb-1">{area.name}</div>
                  <div className="text-2xl font-bold text-primary">{area.score}</div>
                </motion.div>
              );
            })}
          </div>
        </div>
      )}

      {/* Ideal Type Result */}
      {payload.idealType && (
        <div className="px-5 mb-6">
          <h3 className="font-semibold text-foreground mb-3">생성된 이상형</h3>
          <div className="bg-card rounded-2xl p-5 shadow-sm border border-border">
            {payload.idealType.imageUrl && (
              <div className="bg-secondary rounded-xl h-48 mb-4 flex items-center justify-center">
                <span className="text-muted-foreground">이상형 이미지</span>
              </div>
            )}
            <p className="text-sm text-foreground leading-relaxed">
              {payload.idealType.description}
            </p>
          </div>
        </div>
      )}

      {/* Summary */}
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
