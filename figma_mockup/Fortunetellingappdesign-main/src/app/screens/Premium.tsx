import React from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { ArrowLeft, Crown, Check, Sparkles } from 'lucide-react';
import { motion } from 'motion/react';

interface PremiumProps {
  onBack: () => void;
}

export const Premium: React.FC<PremiumProps> = ({ onBack }) => {
  const { t } = useApp();

  const plans = [
    {
      name: '월간',
      price: '9,900원',
      period: '/ 월',
      savings: null,
      popular: false,
    },
    {
      name: '3개월',
      price: '24,900원',
      period: '(월 8,300원)',
      savings: '16% 할인',
      popular: true,
    },
    {
      name: '연간',
      price: '79,900원',
      period: '(월 6,600원)',
      savings: '33% 할인',
      popular: false,
    },
  ];

  const features = [
    '무제한 운세/궁합 확인',
    '모든 전문 상담사와 대화',
    '광고 없는 이용',
    '프리미엄 타로/꿈해몽',
    '관상 분석 무제한',
    '이상형 생성 무제한',
    '우선 매칭 혜택',
    '독점 운세 콘텐츠',
  ];

  return (
    <div className="min-h-screen pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4 flex items-center gap-3">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
          <ArrowLeft size={24} className="text-foreground" />
        </button>
        <div>
          <h1 className="text-2xl font-semibold text-foreground">프리미엄</h1>
        </div>
      </div>

      {/* Hero */}
      <div className="px-5 mb-8">
        <div className="bg-gradient-to-br from-[#C4A574] to-[#8B6F47] rounded-3xl p-8 shadow-xl text-center">
          <div className="bg-white/20 p-4 rounded-2xl w-fit mx-auto mb-4 backdrop-blur-sm">
            <Crown className="text-white" size={48} />
          </div>
          <h2 className="text-2xl font-bold text-white mb-2">Oracle Premium</h2>
          <p className="text-white/90">
            모든 기능을 무제한으로 이용하세요
          </p>
        </div>
      </div>

      {/* Plans */}
      <div className="px-5 mb-8">
        <h3 className="font-semibold text-foreground mb-4">요금제 선택</h3>
        <div className="space-y-3">
          {plans.map((plan, idx) => (
            <motion.button
              key={idx}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: idx * 0.05 }}
              className={`w-full p-5 rounded-2xl border-2 transition-all relative ${
                plan.popular
                  ? 'border-primary bg-primary/5'
                  : 'border-border bg-card hover:border-primary/50'
              }`}
            >
              {plan.popular && (
                <div className="absolute -top-3 left-1/2 -translate-x-1/2">
                  <div className="bg-primary text-primary-foreground px-4 py-1 rounded-full text-xs font-semibold flex items-center gap-1">
                    <Sparkles size={12} />
                    인기
                  </div>
                </div>
              )}
              
              <div className="flex items-center justify-between">
                <div className="text-left">
                  <div className="font-semibold text-foreground mb-1">{plan.name}</div>
                  <div className="flex items-baseline gap-2">
                    <span className="text-2xl font-bold text-primary">{plan.price}</span>
                    <span className="text-sm text-muted-foreground">{plan.period}</span>
                  </div>
                  {plan.savings && (
                    <div className="text-sm text-primary font-medium mt-1">{plan.savings}</div>
                  )}
                </div>
                <div className={`w-6 h-6 rounded-full border-2 ${
                  plan.popular
                    ? 'border-primary bg-primary'
                    : 'border-border'
                } flex items-center justify-center`}>
                  {plan.popular && <Check className="text-primary-foreground" size={16} />}
                </div>
              </div>
            </motion.button>
          ))}
        </div>
      </div>

      {/* Features */}
      <div className="px-5 mb-8">
        <h3 className="font-semibold text-foreground mb-4">프리미엄 혜택</h3>
        <div className="bg-card rounded-2xl p-5 shadow-sm border border-border">
          <div className="space-y-3">
            {features.map((feature, idx) => (
              <div key={idx} className="flex items-center gap-3">
                <div className="w-6 h-6 bg-primary/10 rounded-full flex items-center justify-center flex-shrink-0">
                  <Check className="text-primary" size={16} />
                </div>
                <span className="text-sm text-foreground">{feature}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* CTA */}
      <div className="px-5 mb-4">
        <button className="w-full bg-gradient-to-r from-primary to-[#C4A574] text-white py-4 rounded-2xl font-semibold shadow-lg hover:shadow-xl transition-shadow flex items-center justify-center gap-2">
          <Crown size={20} />
          프리미엄 시작하기
        </button>
      </div>

      {/* Info */}
      <div className="px-5">
        <div className="bg-secondary rounded-xl p-4">
          <p className="text-xs text-muted-foreground leading-relaxed">
            • 첫 7일 무료 체험<br />
            • 언제든지 해지 가능<br />
            • 자동 갱신 (설정에서 변경 가능)<br />
            • 환불 정책: 이용약관 참조
          </p>
        </div>
      </div>
    </div>
  );
};
