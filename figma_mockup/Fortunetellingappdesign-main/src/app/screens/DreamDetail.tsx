import React from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { ArrowLeft, Moon, Sparkles, TrendingUp, AlertCircle } from 'lucide-react';
import { motion } from 'motion/react';

interface DreamDetailProps {
  onBack: () => void;
  data?: any;
}

export const DreamDetail: React.FC<DreamDetailProps> = ({ onBack, data }) => {
  const { t } = useApp();

  const item = data?.item;
  const payload = item?.payload || {};

  const typeColors: any = {
    good: 'bg-green-500',
    neutral: 'bg-yellow-500',
    warning: 'bg-orange-500',
  };

  const typeIcons: any = {
    good: Sparkles,
    neutral: Moon,
    warning: AlertCircle,
  };

  const dreamType = payload.type || 'good';
  const TypeIcon = typeIcons[dreamType];

  return (
    <div className="pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4 flex items-center gap-3">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
          <ArrowLeft size={24} className="text-foreground" />
        </button>
        <div className="flex-1">
          <h1 className="text-2xl font-semibold text-foreground">{item?.title || '꿈해몽'}</h1>
          <p className="text-sm text-muted-foreground">{item?.dateLabel}</p>
        </div>
      </div>

      {/* Dream Type */}
      <div className="px-5 mb-6">
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          className={`bg-gradient-to-br from-[#C4A574] to-[#9DB4A0] rounded-2xl p-6 shadow-lg`}
        >
          <div className="bg-white/20 p-3 rounded-full w-fit mx-auto mb-4 backdrop-blur-sm">
            <Moon className="text-white" size={32} />
          </div>
          
          <div className="text-center">
            <div className="text-white/90 text-sm mb-2">꿈의 의미</div>
            <div className="flex items-center justify-center gap-2 mb-3">
              <TypeIcon className="text-white" size={24} />
              <span className="text-2xl font-bold text-white">
                {dreamType === 'good' ? '길몽' : dreamType === 'warning' ? '경고몽' : '보통몽'}
              </span>
            </div>
            
            {payload.dreamContent && (
              <div className="bg-white/10 rounded-2xl p-4 backdrop-blur-sm">
                <div className="text-white text-sm">
                  {payload.dreamContent}
                </div>
              </div>
            )}
          </div>
        </motion.div>
      </div>

      {/* Interpretation */}
      {payload.interpretation && (
        <div className="px-5 mb-6">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="bg-card rounded-2xl p-5 shadow-sm border border-border"
          >
            <h3 className="font-semibold text-foreground mb-3 flex items-center gap-2">
              <Sparkles className="text-primary" size={20} />
              해몽 해석
            </h3>
            <p className="text-sm text-foreground leading-relaxed mb-4">
              {payload.interpretation}
            </p>
            
            {payload.keywords && (
              <div className="flex flex-wrap gap-2">
                {payload.keywords.map((keyword: string, idx: number) => (
                  <span
                    key={idx}
                    className="px-3 py-1 bg-primary/10 text-primary text-xs rounded-full"
                  >
                    {keyword}
                  </span>
                ))}
              </div>
            )}
          </motion.div>
        </div>
      )}

      {/* Symbols */}
      {payload.symbols && (
        <div className="px-5 mb-6">
          <h3 className="font-semibold text-foreground mb-3">주요 상징</h3>
          <div className="space-y-3">
            {payload.symbols.map((symbol: any, idx: number) => (
              <motion.div
                key={idx}
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                transition={{ delay: idx * 0.1 }}
                className="bg-card rounded-xl p-4 shadow-sm border border-border"
              >
                <div className="flex items-start gap-3">
                  <div className="text-2xl">{symbol.icon || '🌟'}</div>
                  <div className="flex-1">
                    <h4 className="font-medium text-foreground mb-1">{symbol.name}</h4>
                    <p className="text-sm text-muted-foreground">{symbol.meaning}</p>
                  </div>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      )}

      {/* Advice */}
      {payload.advice && (
        <div className="px-5 mb-6">
          <div className="bg-gradient-to-br from-primary/10 to-transparent rounded-2xl p-5 border border-primary/20">
            <div className="flex items-start gap-3">
              <TrendingUp className="text-primary flex-shrink-0" size={20} />
              <div>
                <h3 className="font-semibold text-foreground mb-2">조언</h3>
                <p className="text-sm text-foreground leading-relaxed">
                  {payload.advice}
                </p>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Summary */}
      {item?.summary && (
        <div className="px-5 mb-6">
          <div className="bg-card rounded-2xl p-5 shadow-sm border border-border">
            <p className="text-sm text-muted-foreground">
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
