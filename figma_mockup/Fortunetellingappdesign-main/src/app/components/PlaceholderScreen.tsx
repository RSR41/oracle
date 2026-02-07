import React from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { ArrowLeft } from 'lucide-react';
import { motion } from 'motion/react';

interface PlaceholderScreenProps {
  onBack: () => void;
  title: string;
  description?: string;
  icon?: string;
}

export const PlaceholderScreen: React.FC<PlaceholderScreenProps> = ({ 
  onBack, 
  title, 
  description = '이 기능은 곧 추가될 예정입니다',
  icon = '🚧'
}) => {
  const { t } = useApp();

  return (
    <div className="min-h-screen pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4 flex items-center gap-3">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
          <ArrowLeft size={24} className="text-foreground" />
        </button>
        <div>
          <h1 className="text-2xl font-semibold text-foreground">{title}</h1>
        </div>
      </div>

      {/* Content */}
      <div className="flex items-center justify-center px-5 pt-20">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-center"
        >
          <div className="bg-primary/10 p-8 rounded-3xl mx-auto w-fit mb-6">
            <div className="text-6xl">{icon}</div>
          </div>
          <h2 className="text-xl font-semibold text-foreground mb-3">준비 중입니다</h2>
          <p className="text-sm text-muted-foreground mb-8 max-w-sm">
            {description}
          </p>
          <button
            onClick={onBack}
            className="px-8 py-3 bg-primary text-primary-foreground rounded-xl font-medium hover:bg-primary/90 transition-colors"
          >
            돌아가기
          </button>
        </motion.div>
      </div>
    </div>
  );
};
