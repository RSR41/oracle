import React, { useState } from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { ArrowLeft, Heart, X, MessageCircle, Info } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';
import { ImageWithFallback } from '@/app/components/figma/ImageWithFallback';

interface ConnectionProps {
  onBack: () => void;
  onNavigate: (screen: string, data?: any) => void;
}

export const Connection: React.FC<ConnectionProps> = ({ onBack, onNavigate }) => {
  const { t } = useApp();
  const [currentIndex, setCurrentIndex] = useState(0);

  // Mock user data
  const users = [
    {
      id: 1,
      name: '김서연',
      age: 28,
      compatibility: 92,
      description: '따뜻하고 배려심 있는 성격',
      interests: ['독서', '요리', '여행'],
      image: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=600&fit=crop',
    },
    {
      id: 2,
      name: '이민준',
      age: 30,
      compatibility: 88,
      description: '활발하고 유머러스한 성격',
      interests: ['운동', '영화', '음악'],
      image: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=600&fit=crop',
    },
    {
      id: 3,
      name: '박지은',
      age: 27,
      compatibility: 85,
      description: '차분하고 사려 깊은 성격',
      interests: ['사진', '카페', '전시'],
      image: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&h=600&fit=crop',
    },
  ];

  const currentUser = users[currentIndex];

  const handleLike = () => {
    if (currentIndex < users.length - 1) {
      setCurrentIndex(currentIndex + 1);
    } else {
      setCurrentIndex(0);
    }
  };

  const handlePass = () => {
    if (currentIndex < users.length - 1) {
      setCurrentIndex(currentIndex + 1);
    } else {
      setCurrentIndex(0);
    }
  };

  return (
    <div className="min-h-screen pb-20 bg-background">
      {/* Header */}
      <div className="px-5 pt-6 pb-4 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
            <ArrowLeft size={24} className="text-foreground" />
          </button>
          <div>
            <div className="flex items-center gap-2">
              <h1 className="text-2xl font-semibold text-foreground">{t('connection.title')}</h1>
              <span className="text-xs px-2 py-0.5 bg-primary/10 text-primary rounded-full">
                {t('connection.beta')}
              </span>
            </div>
          </div>
        </div>
        <button className="p-2 hover:bg-secondary rounded-xl transition-colors">
          <Info size={20} className="text-foreground" />
        </button>
      </div>

      {/* Info Banner */}
      <div className="px-5 mb-6">
        <div className="bg-primary/5 border border-primary/20 rounded-2xl p-4">
          <p className="text-sm text-muted-foreground">
            사주와 관상 분석을 바탕으로 궁합이 좋은 분들을 추천해드립니다
          </p>
        </div>
      </div>

      {/* Card Stack */}
      <div className="px-5 mb-6">
        <div className="relative h-[500px]">
          <AnimatePresence>
            {currentUser && (
              <motion.div
                key={currentUser.id}
                initial={{ scale: 0.95, opacity: 0 }}
                animate={{ scale: 1, opacity: 1 }}
                exit={{ scale: 0.95, opacity: 0 }}
                className="absolute inset-0 bg-card rounded-3xl shadow-2xl overflow-hidden"
              >
                {/* Image */}
                <div className="relative h-[65%]">
                  <ImageWithFallback
                    src={currentUser.image}
                    alt={currentUser.name}
                    className="w-full h-full object-cover"
                  />
                  
                  {/* Compatibility Badge */}
                  <div className="absolute top-4 right-4 bg-gradient-to-br from-primary to-[#C4A574] px-4 py-2 rounded-full shadow-lg">
                    <div className="text-white text-xs mb-0.5">{t('connection.compatScore')}</div>
                    <div className="text-white text-xl font-bold">{currentUser.compatibility}</div>
                  </div>

                  {/* Gradient Overlay */}
                  <div className="absolute bottom-0 left-0 right-0 h-24 bg-gradient-to-t from-card to-transparent" />
                </div>

                {/* Info */}
                <div className="p-6">
                  <div className="mb-4">
                    <h2 className="text-2xl font-bold text-foreground mb-1">
                      {currentUser.name}, {currentUser.age}
                    </h2>
                    <p className="text-sm text-muted-foreground">{currentUser.description}</p>
                  </div>

                  {/* Interests */}
                  <div className="flex flex-wrap gap-2">
                    {currentUser.interests.map((interest, idx) => (
                      <span
                        key={idx}
                        className="px-3 py-1.5 bg-primary/10 text-primary text-sm rounded-full"
                      >
                        {interest}
                      </span>
                    ))}
                  </div>
                </div>
              </motion.div>
            )}
          </AnimatePresence>
        </div>
      </div>

      {/* Action Buttons */}
      <div className="px-5">
        <div className="flex items-center justify-center gap-6">
          <motion.button
            whileTap={{ scale: 0.9 }}
            onClick={handlePass}
            className="w-16 h-16 bg-card border-2 border-border rounded-full flex items-center justify-center shadow-lg hover:border-destructive/50 hover:bg-destructive/5 transition-colors"
          >
            <X className="text-destructive" size={28} strokeWidth={2.5} />
          </motion.button>

          <motion.button
            whileTap={{ scale: 0.9 }}
            onClick={handleLike}
            className="w-20 h-20 bg-gradient-to-br from-primary to-[#C4A574] rounded-full flex items-center justify-center shadow-xl hover:shadow-2xl transition-shadow"
          >
            <Heart className="text-white fill-white" size={32} />
          </motion.button>

          <motion.button
            whileTap={{ scale: 0.9 }}
            onClick={() => onNavigate('chat')}
            className="w-16 h-16 bg-card border-2 border-border rounded-full flex items-center justify-center shadow-lg hover:border-primary/50 hover:bg-primary/5 transition-colors"
          >
            <MessageCircle className="text-primary" size={28} />
          </motion.button>
        </div>
      </div>

      {/* Bottom Tabs */}
      <div className="px-5 mt-8">
        <div className="grid grid-cols-3 gap-3">
          <button className="py-3 bg-primary/10 text-primary rounded-xl font-medium">
            {t('connection.recommendations')}
          </button>
          <button className="py-3 bg-card border border-border rounded-xl font-medium text-foreground hover:bg-secondary transition-colors">
            {t('connection.likes')}
          </button>
          <button className="py-3 bg-card border border-border rounded-xl font-medium text-foreground hover:bg-secondary transition-colors">
            {t('connection.matches')}
          </button>
        </div>
      </div>
    </div>
  );
};
