import React from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { ArrowLeft, Sparkles } from 'lucide-react';
import { motion } from 'motion/react';

interface TarotDetailProps {
  onBack: () => void;
  data?: any;
}

export const TarotDetail: React.FC<TarotDetailProps> = ({ onBack, data }) => {
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
          <h1 className="text-2xl font-semibold text-foreground">{item?.title || '타로 리딩'}</h1>
          <p className="text-sm text-muted-foreground">{item?.dateLabel}</p>
        </div>
      </div>

      {/* Question */}
      {payload.question && (
        <div className="px-5 mb-6">
          <div className="bg-gradient-to-br from-[#B8D4E8] to-[#9DB4A0] rounded-2xl p-5 shadow-lg">
            <div className="text-white/90 text-sm mb-2">질문</div>
            <div className="text-white text-lg font-medium">
              {payload.question}
            </div>
          </div>
        </div>
      )}

      {/* Cards */}
      {payload.cards && (
        <div className="px-5 mb-6 space-y-4">
          {payload.cards.map((card: any, idx: number) => (
            <motion.div
              key={idx}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: idx * 0.15 }}
              className="bg-card rounded-2xl p-5 shadow-sm border border-border"
            >
              <div className="flex items-start gap-4 mb-4">
                <div className="bg-gradient-to-br from-[#B8D4E8] to-[#C4A574] p-4 rounded-xl flex-shrink-0">
                  <Sparkles className="text-white" size={24} />
                </div>
                <div className="flex-1">
                  <div className="text-xs text-muted-foreground mb-1">
                    {card.position || `카드 ${idx + 1}`}
                  </div>
                  <h3 className="text-lg font-semibold text-foreground mb-1">
                    {card.name}
                  </h3>
                  {card.reversed && (
                    <span className="text-xs text-destructive">역방향</span>
                  )}
                </div>
              </div>
              
              {card.keywords && (
                <div className="flex flex-wrap gap-2 mb-3">
                  {card.keywords.map((keyword: string, kidx: number) => (
                    <span
                      key={kidx}
                      className="px-3 py-1 bg-primary/10 text-primary text-xs rounded-full"
                    >
                      {keyword}
                    </span>
                  ))}
                </div>
              )}
              
              <p className="text-sm text-foreground leading-relaxed">
                {card.interpretation}
              </p>
            </motion.div>
          ))}
        </div>
      )}

      {/* Overall Interpretation */}
      {payload.overall && (
        <div className="px-5 mb-6">
          <div className="bg-gradient-to-br from-primary/10 to-transparent rounded-2xl p-5 border border-primary/20">
            <h3 className="font-semibold text-foreground mb-3">종합 해석</h3>
            <p className="text-sm text-foreground leading-relaxed">
              {payload.overall}
            </p>
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
