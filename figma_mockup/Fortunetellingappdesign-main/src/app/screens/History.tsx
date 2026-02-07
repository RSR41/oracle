import React, { useState } from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { Sparkles, Heart, Shuffle, Moon, Scan, Calendar as CalendarIcon, ChevronRight } from 'lucide-react';
import { motion } from 'motion/react';

interface HistoryProps {
  onNavigate: (screen: string, data?: any) => void;
}

export const History: React.FC<HistoryProps> = ({ onNavigate }) => {
  const { t, historyItems } = useApp();
  const [selectedFilter, setSelectedFilter] = useState<string>('all');

  const filters = [
    { id: 'all', label: '전체' },
    { id: 'fortune', label: '운세' },
    { id: 'compat', label: '궁합' },
    { id: 'tarot', label: '타로' },
    { id: 'face', label: '관상' },
    { id: 'dream', label: '꿈해몽' },
  ];

  const filteredItems = selectedFilter === 'all' 
    ? historyItems 
    : historyItems.filter(item => item.type === selectedFilter);

  const iconMap: any = {
    fortune: Sparkles,
    compat: Heart,
    tarot: Shuffle,
    face: Scan,
    dream: Moon,
  };

  const colorMap: any = {
    fortune: 'bg-[#8B6F47]',
    compat: 'bg-[#E9C5B5]',
    tarot: 'bg-[#B8D4E8]',
    face: 'bg-[#E9C5B5]',
    dream: 'bg-[#C4A574]',
  };

  return (
    <div className="pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4">
        <h1 className="text-2xl font-semibold text-foreground mb-1">{t('nav.history')}</h1>
        <p className="text-sm text-muted-foreground">저장한 운세와 분석 결과</p>
      </div>

      {/* Filters */}
      <div className="px-5 mb-6 overflow-x-auto">
        <div className="flex gap-2 pb-2">
          {filters.map((filter) => (
            <button
              key={filter.id}
              onClick={() => setSelectedFilter(filter.id)}
              className={`px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-colors ${
                selectedFilter === filter.id
                  ? 'bg-primary text-primary-foreground'
                  : 'bg-secondary text-secondary-foreground hover:bg-primary/10'
              }`}
            >
              {filter.label}
            </button>
          ))}
        </div>
      </div>

      {/* History List */}
      <div className="px-5 space-y-3">
        {filteredItems.length === 0 ? (
          <div className="py-20 text-center">
            <div className="bg-secondary p-6 rounded-2xl mx-auto w-fit mb-4">
              <Sparkles className="text-muted-foreground" size={48} />
            </div>
            <h3 className="font-semibold text-foreground mb-2">저장된 기록이 없습니다</h3>
            <p className="text-sm text-muted-foreground">
              운세를 확인하고 결과를 저장해보세요
            </p>
          </div>
        ) : (
          filteredItems.map((item, idx) => {
            const Icon = iconMap[item.type] || Sparkles;
            const color = colorMap[item.type] || 'bg-[#8B6F47]';
            
            return (
              <motion.button
                key={item.id}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: idx * 0.05 }}
                onClick={() => onNavigate(`${item.type}-detail`, { id: item.id, item: item })}
                className="w-full bg-card rounded-2xl p-4 shadow-sm border border-border hover:shadow-md transition-all text-left"
              >
                <div className="flex items-start gap-4">
                  <div className={`${color} p-3 rounded-xl flex-shrink-0`}>
                    <Icon className="text-white" size={24} />
                  </div>
                  
                  <div className="flex-1 min-w-0">
                    <div className="flex items-start justify-between mb-1">
                      <h3 className="font-semibold text-foreground truncate">
                        {item.title}
                      </h3>
                      {item.score && (
                        <div className="text-2xl font-bold text-primary ml-3 flex-shrink-0">
                          {item.score}
                        </div>
                      )}
                    </div>
                    
                    <div className="text-sm text-muted-foreground mb-2">
                      {item.dateLabel}
                    </div>
                    
                    {item.summary && (
                      <p className="text-sm text-foreground">
                        {item.summary}
                      </p>
                    )}
                  </div>
                  
                  <ChevronRight className="text-muted-foreground flex-shrink-0 mt-1" size={20} />
                </div>
              </motion.button>
            );
          })
        )}
      </div>

      {/* Stats Summary (optional) */}
      {filteredItems.length > 0 && (
        <div className="px-5 mt-6">
          <div className="bg-gradient-to-br from-primary/10 to-transparent rounded-2xl p-5 border border-primary/20">
            <h3 className="font-semibold text-foreground mb-3">이번 달 통계</h3>
            <div className="grid grid-cols-3 gap-3">
              <div className="text-center">
                <div className="text-2xl font-bold text-primary">12</div>
                <div className="text-xs text-muted-foreground mt-1">운세 확인</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold text-primary">5</div>
                <div className="text-xs text-muted-foreground mt-1">궁합 확인</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold text-primary">3</div>
                <div className="text-xs text-muted-foreground mt-1">타로 리딩</div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};