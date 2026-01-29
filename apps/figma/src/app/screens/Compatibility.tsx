import React, { useState } from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { OracleCard } from '@/app/components/OracleCard';
import { Heart, Users, Briefcase, Plus, ChevronRight } from 'lucide-react';
import { motion } from 'motion/react';

interface CompatibilityProps {
  onNavigate: (screen: string, data?: any) => void;
}

export const Compatibility: React.FC<CompatibilityProps> = ({ onNavigate }) => {
  const { t } = useApp();
  const [selectedType, setSelectedType] = useState<'love' | 'friend' | 'business'>('love');

  const compatibilityTypes = [
    { id: 'love', label: t('compat.love'), icon: Heart, color: 'bg-[#E9C5B5]' },
    { id: 'friend', label: t('compat.friend'), icon: Users, color: 'bg-[#9DB4A0]' },
    { id: 'business', label: t('compat.business'), icon: Briefcase, color: 'bg-[#B8D4E8]' },
  ];

  // Mock saved compatibility checks
  const savedCompatibilities = [
    { name: '김민수', type: 'love', score: 92, date: '2026.01.25' },
    { name: '이지은', type: 'friend', score: 85, date: '2026.01.20' },
    { name: '박서준', type: 'business', score: 78, date: '2026.01.15' },
  ];

  return (
    <div className="pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4">
        <h1 className="text-2xl font-semibold text-foreground mb-1">{t('compat.title')}</h1>
        <p className="text-sm text-muted-foreground">궁합을 확인하고 인연을 찾아보세요</p>
      </div>

      {/* Type Selection */}
      <div className="px-5 mb-6">
        <div className="grid grid-cols-3 gap-3">
          {compatibilityTypes.map((type) => {
            const Icon = type.icon;
            const isSelected = selectedType === type.id;
            
            return (
              <motion.button
                key={type.id}
                whileTap={{ scale: 0.95 }}
                onClick={() => setSelectedType(type.id as any)}
                className={`p-4 rounded-2xl border-2 transition-all ${
                  isSelected
                    ? 'border-primary bg-primary/5 shadow-md'
                    : 'border-border bg-card hover:border-primary/50'
                }`}
              >
                <div className={`${type.color} p-3 rounded-xl mx-auto w-fit mb-2`}>
                  <Icon className="text-white" size={20} />
                </div>
                <div className={`text-sm font-medium ${
                  isSelected ? 'text-primary' : 'text-foreground'
                }`}>
                  {type.label}
                </div>
              </motion.button>
            );
          })}
        </div>
      </div>

      {/* New Compatibility Check */}
      <div className="px-5 mb-6">
        <motion.button
          whileTap={{ scale: 0.98 }}
          onClick={() => onNavigate('compat-check', { type: selectedType })}
          className="w-full bg-gradient-to-br from-primary to-[#C4A574] rounded-2xl p-6 shadow-lg text-left"
        >
          <div className="flex items-center justify-between">
            <div>
              <div className="text-white text-lg font-semibold mb-1">
                {t('compat.check')}
              </div>
              <div className="text-white/80 text-sm">
                {t('compat.enterPartner')}
              </div>
            </div>
            <div className="bg-white/20 p-3 rounded-xl backdrop-blur-sm">
              <Plus className="text-white" size={24} />
            </div>
          </div>
        </motion.button>
      </div>

      {/* Saved Compatibilities */}
      <div className="px-5 mb-6">
        <div className="flex items-center justify-between mb-3">
          <h2 className="font-semibold text-foreground">최근 확인한 궁합</h2>
          <button className="text-sm text-primary font-medium flex items-center gap-1">
            {t('compat.viewMore')}
            <ChevronRight size={16} />
          </button>
        </div>
        
        <div className="space-y-3">
          {savedCompatibilities.map((item, idx) => (
            <motion.button
              key={idx}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: idx * 0.05 }}
              onClick={() => onNavigate('compat-result', { data: item })}
              className="w-full bg-card rounded-2xl p-4 shadow-sm border border-border hover:shadow-md transition-all text-left"
            >
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 rounded-full bg-gradient-to-br from-primary/20 to-primary/5 flex items-center justify-center">
                    <span className="text-primary font-semibold">
                      {item.name.charAt(0)}
                    </span>
                  </div>
                  <div>
                    <div className="font-semibold text-foreground">{item.name}</div>
                    <div className="text-xs text-muted-foreground">{item.date}</div>
                  </div>
                </div>
                <div className="text-right">
                  <div className="text-2xl font-bold text-primary">{item.score}</div>
                  <div className="text-xs text-muted-foreground">{t('compat.score')}</div>
                </div>
              </div>
            </motion.button>
          ))}
        </div>
      </div>

      {/* Connection Feature CTA (Hidden Social) */}
      <div className="px-5 mb-6">
        <div className="bg-gradient-to-br from-[#9DB4A0]/20 to-transparent rounded-2xl p-5 border border-[#9DB4A0]/30">
          <div className="flex items-start gap-3 mb-4">
            <div className="bg-[#9DB4A0] p-2.5 rounded-xl">
              <Users className="text-white" size={20} />
            </div>
            <div>
              <div className="font-semibold text-foreground mb-1">
                {t('compat.findSimilar')}
              </div>
              <div className="text-sm text-muted-foreground">
                나와 궁합이 잘 맞는 사람들을 추천받아보세요
              </div>
            </div>
          </div>
          <button
            onClick={() => onNavigate('connection')}
            className="w-full bg-[#9DB4A0] hover:bg-[#8DA390] text-white py-2.5 rounded-xl text-sm font-medium transition-colors"
          >
            인연 보기 →
          </button>
        </div>
      </div>

      {/* Info */}
      <div className="px-5 pb-4">
        <p className="text-xs text-muted-foreground text-center">
          {t('common.entertainment')}
        </p>
      </div>
    </div>
  );
};
