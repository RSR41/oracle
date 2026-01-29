import React, { useState } from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { Sparkles, Heart, Moon, ChevronRight } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';

interface OnboardingProps {
  onComplete: () => void;
}

export const Onboarding: React.FC<OnboardingProps> = ({ onComplete }) => {
  const { t } = useApp();
  const [currentSlide, setCurrentSlide] = useState(0);

  const slides = [
    {
      icon: Sparkles,
      title: '운세와 사주',
      description: '매일의 운세부터 자세한 사주 분석까지\n당신의 운명을 확인하세요',
      color: 'from-[#8B6F47] to-[#C4A574]',
    },
    {
      icon: Heart,
      title: '궁합 분석',
      description: '연인, 친구, 비즈니스 파트너와의\n궁합을 확인해보세요',
      color: 'from-[#E9C5B5] to-[#C4A574]',
    },
    {
      icon: Moon,
      title: '타로와 꿈해몽',
      description: '타로 카드로 미래를 엿보고\n꿈의 의미를 해석해보세요',
      color: 'from-[#B8D4E8] to-[#9DB4A0]',
    },
  ];

  const handleNext = () => {
    if (currentSlide < slides.length - 1) {
      setCurrentSlide(currentSlide + 1);
    } else {
      onComplete();
    }
  };

  return (
    <div className="min-h-screen flex flex-col bg-background">
      {/* Skip Button */}
      <div className="px-5 pt-6 flex justify-end">
        <button
          onClick={onComplete}
          className="text-sm text-muted-foreground hover:text-foreground transition-colors"
        >
          건너뛰기
        </button>
      </div>

      {/* Slides */}
      <div className="flex-1 flex items-center justify-center px-5">
        <AnimatePresence mode="wait">
          <motion.div
            key={currentSlide}
            initial={{ opacity: 0, x: 100 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -100 }}
            transition={{ duration: 0.3 }}
            className="w-full max-w-sm"
          >
            <div className={`bg-gradient-to-br ${slides[currentSlide].color} rounded-3xl p-8 mb-8 shadow-2xl`}>
              <div className="bg-white/20 p-6 rounded-2xl w-fit mx-auto mb-6 backdrop-blur-sm">
                {React.createElement(slides[currentSlide].icon, {
                  size: 64,
                  className: 'text-white',
                })}
              </div>
            </div>

            <div className="text-center">
              <h2 className="text-2xl font-bold text-foreground mb-4">
                {slides[currentSlide].title}
              </h2>
              <p className="text-base text-muted-foreground leading-relaxed whitespace-pre-line">
                {slides[currentSlide].description}
              </p>
            </div>
          </motion.div>
        </AnimatePresence>
      </div>

      {/* Indicators */}
      <div className="flex justify-center gap-2 mb-8">
        {slides.map((_, idx) => (
          <button
            key={idx}
            onClick={() => setCurrentSlide(idx)}
            className={`h-2 rounded-full transition-all ${
              idx === currentSlide
                ? 'w-8 bg-primary'
                : 'w-2 bg-border'
            }`}
          />
        ))}
      </div>

      {/* Next Button */}
      <div className="px-5 pb-8">
        <button
          onClick={handleNext}
          className="w-full bg-primary text-primary-foreground py-4 rounded-2xl font-semibold flex items-center justify-center gap-2 hover:bg-primary/90 transition-colors shadow-lg"
        >
          {currentSlide < slides.length - 1 ? '다음' : '시작하기'}
          <ChevronRight size={20} />
        </button>
      </div>

      {/* Disclaimer */}
      <div className="px-5 pb-6">
        <p className="text-xs text-muted-foreground text-center">
          {t('common.entertainment')}
        </p>
      </div>
    </div>
  );
};
