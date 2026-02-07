import React, { useState } from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { ArrowLeft, Calendar as CalendarIcon, ChevronLeft, ChevronRight } from 'lucide-react';
import { motion } from 'motion/react';

interface CalendarScreenProps {
  onBack: () => void;
}

export const CalendarScreen: React.FC<CalendarScreenProps> = ({ onBack }) => {
  const { t } = useApp();
  const [selectedTab, setSelectedTab] = useState<'day' | 'week' | 'month'>('day');
  const [selectedDate, setSelectedDate] = useState(30);

  const tabs = [
    { id: 'day', label: '일운' },
    { id: 'week', label: '주운' },
    { id: 'month', label: '월운' },
  ];

  const weekDays = ['월', '화', '수', '목', '금', '토', '일'];
  const dates = Array.from({ length: 31 }, (_, i) => i + 1);

  const fortuneScores = {
    28: 72, 29: 85, 30: 88, 31: 65, 1: 90, 2: 78, 3: 82,
  };

  const getScoreColor = (score: number) => {
    if (score >= 85) return 'bg-green-500';
    if (score >= 70) return 'bg-[#C4A574]';
    return 'bg-yellow-500';
  };

  return (
    <div className="pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4 flex items-center gap-3">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
          <ArrowLeft size={24} className="text-foreground" />
        </button>
        <div>
          <h1 className="text-2xl font-semibold text-foreground">만세력</h1>
          <p className="text-sm text-muted-foreground">일/주/월 운세 확인</p>
        </div>
      </div>

      {/* Tabs */}
      <div className="px-5 mb-6">
        <div className="flex gap-2 bg-secondary p-1 rounded-2xl">
          {tabs.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setSelectedTab(tab.id as any)}
              className={`flex-1 py-2.5 rounded-xl font-medium text-sm transition-all ${
                selectedTab === tab.id
                  ? 'bg-primary text-primary-foreground shadow-sm'
                  : 'text-foreground hover:bg-card'
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>
      </div>

      {/* Month Navigation */}
      <div className="px-5 mb-6">
        <div className="flex items-center justify-between mb-4">
          <button className="p-2 hover:bg-secondary rounded-xl transition-colors">
            <ChevronLeft size={20} className="text-foreground" />
          </button>
          <div className="text-center">
            <h2 className="text-lg font-semibold text-foreground">2026년 1월</h2>
            <p className="text-xs text-muted-foreground">병오년 경인월</p>
          </div>
          <button className="p-2 hover:bg-secondary rounded-xl transition-colors">
            <ChevronRight size={20} className="text-foreground" />
          </button>
        </div>
      </div>

      {selectedTab === 'day' && (
        <>
          {/* Calendar Grid */}
          <div className="px-5 mb-6">
            <div className="bg-card rounded-2xl p-4 shadow-sm border border-border">
              {/* Week Days */}
              <div className="grid grid-cols-7 gap-2 mb-3">
                {weekDays.map((day, idx) => (
                  <div key={idx} className="text-center text-xs font-medium text-muted-foreground py-2">
                    {day}
                  </div>
                ))}
              </div>

              {/* Dates */}
              <div className="grid grid-cols-7 gap-2">
                {/* Previous month padding */}
                {[29, 30, 31].map((date) => (
                  <button
                    key={`prev-${date}`}
                    className="aspect-square flex flex-col items-center justify-center rounded-xl text-muted-foreground/30 text-sm"
                  >
                    {date}
                  </button>
                ))}
                
                {/* Current month */}
                {dates.map((date) => {
                  const score = fortuneScores[date] || Math.floor(Math.random() * 30) + 70;
                  const isSelected = date === selectedDate;
                  const isToday = date === 30;
                  
                  return (
                    <button
                      key={date}
                      onClick={() => setSelectedDate(date)}
                      className={`aspect-square flex flex-col items-center justify-center rounded-xl transition-all ${
                        isSelected
                          ? 'bg-primary text-primary-foreground shadow-md scale-105'
                          : isToday
                          ? 'bg-primary/10 text-primary'
                          : 'hover:bg-secondary'
                      }`}
                    >
                      <div className="text-sm font-medium">{date}</div>
                      {!isSelected && (
                        <div className={`w-1 h-1 rounded-full mt-1 ${getScoreColor(score)}`} />
                      )}
                    </button>
                  );
                })}
              </div>
            </div>
          </div>

          {/* Selected Date Fortune */}
          <div className="px-5 mb-6">
            <motion.div
              key={selectedDate}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              className="bg-gradient-to-br from-primary to-[#C4A574] rounded-3xl p-6 shadow-lg"
            >
              <div className="flex items-center justify-between mb-4">
                <div>
                  <div className="text-white/90 text-sm mb-1">1월 {selectedDate}일</div>
                  <div className="text-white text-xl font-semibold">일운세</div>
                </div>
                <div className="bg-white/20 p-3 rounded-xl backdrop-blur-sm">
                  <div className="text-white text-3xl font-bold">
                    {fortuneScores[selectedDate] || 75}
                  </div>
                </div>
              </div>

              <div className="bg-white/10 rounded-2xl p-4 backdrop-blur-sm">
                <div className="text-white/90 text-sm mb-2">오늘의 운세</div>
                <div className="text-white text-sm leading-relaxed">
                  {selectedDate === 30
                    ? '새로운 시작을 위한 준비가 필요한 날입니다. 작은 변화가 큰 결과를 가져올 수 있습니다.'
                    : '긍정적인 에너지가 흐르는 날입니다. 적극적으로 행동하면 좋은 결과가 있을 것입니다.'}
                </div>
              </div>

              <div className="grid grid-cols-3 gap-2 mt-4">
                {['애정', '재물', '건강'].map((item, idx) => (
                  <div key={idx} className="bg-white/10 rounded-xl p-2.5 backdrop-blur-sm text-center">
                    <div className="text-white/80 text-xs mb-1">{item}</div>
                    <div className="text-white font-semibold text-sm">
                      {['좋음', '보통', '주의'][idx]}
                    </div>
                  </div>
                ))}
              </div>
            </motion.div>
          </div>
        </>
      )}

      {selectedTab === 'week' && (
        <div className="px-5 mb-6">
          <div className="bg-card rounded-2xl p-5 shadow-sm border border-border">
            <h3 className="font-semibold text-foreground mb-4">이번 주 운세 (1/27 - 2/2)</h3>
            
            <div className="space-y-3 mb-6">
              {weekDays.slice(0, 7).map((day, idx) => {
                const date = 27 + idx;
                const score = fortuneScores[date > 31 ? date - 31 : date] || Math.floor(Math.random() * 30) + 70;
                
                return (
                  <div key={idx} className="flex items-center gap-3">
                    <div className="w-12 text-sm font-medium text-foreground">{day}</div>
                    <div className="flex-1 bg-secondary rounded-full h-2 overflow-hidden">
                      <div
                        className={`h-full ${getScoreColor(score)} transition-all`}
                        style={{ width: `${score}%` }}
                      />
                    </div>
                    <div className="w-12 text-right text-sm font-semibold text-primary">{score}</div>
                  </div>
                );
              })}
            </div>

            <div className="bg-primary/5 rounded-xl p-4 border border-primary/20">
              <h4 className="text-sm font-semibold text-foreground mb-2">주간 요약</h4>
              <p className="text-sm text-muted-foreground leading-relaxed">
                이번 주는 전반적으로 좋은 운세가 예상됩니다. 특히 목요일과 금요일이 가장 좋으며, 
                중요한 일은 이 시기에 진행하시는 것을 추천합니다.
              </p>
            </div>
          </div>
        </div>
      )}

      {selectedTab === 'month' && (
        <div className="px-5 mb-6">
          <div className="bg-card rounded-2xl p-5 shadow-sm border border-border">
            <h3 className="font-semibold text-foreground mb-4">1월 월운세</h3>
            
            <div className="grid grid-cols-2 gap-3 mb-6">
              {[
                { label: '총운', score: 82, icon: '✨' },
                { label: '애정운', score: 88, icon: '💕' },
                { label: '재물운', score: 75, icon: '💰' },
                { label: '건강운', score: 85, icon: '💪' },
              ].map((item, idx) => (
                <div key={idx} className="bg-secondary rounded-xl p-4">
                  <div className="flex items-center gap-2 mb-2">
                    <span className="text-xl">{item.icon}</span>
                    <div className="text-sm font-medium text-foreground">{item.label}</div>
                  </div>
                  <div className="text-2xl font-bold text-primary">{item.score}</div>
                </div>
              ))}
            </div>

            <div className="bg-primary/5 rounded-xl p-4 border border-primary/20 mb-4">
              <h4 className="text-sm font-semibold text-foreground mb-2">월간 운세</h4>
              <p className="text-sm text-muted-foreground leading-relaxed mb-3">
                새해의 시작인 1월은 새로운 계획을 세우고 준비하기 좋은 달입니다. 
                인간관계에서 좋은 인연을 만날 수 있으며, 재물운도 안정적입니다.
              </p>
              <p className="text-sm text-muted-foreground leading-relaxed">
                중순 이후부터는 건강관리에 신경 쓰시고, 과로를 피하는 것이 좋습니다.
              </p>
            </div>

            <div className="space-y-2">
              <div className="flex items-center justify-between py-2">
                <span className="text-sm text-muted-foreground">길일</span>
                <span className="text-sm font-semibold text-foreground">1/1, 1/7, 1/15, 1/23</span>
              </div>
              <div className="flex items-center justify-between py-2 border-t border-border">
                <span className="text-sm text-muted-foreground">주의일</span>
                <span className="text-sm font-semibold text-foreground">1/10, 1/18, 1/26</span>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Actions */}
      <div className="px-5 mb-6 flex gap-3">
        <button className="flex-1 py-3 bg-card border border-border rounded-xl font-medium hover:bg-secondary transition-colors">
          {t('common.save')}
        </button>
        <button className="flex-1 py-3 bg-primary text-primary-foreground rounded-xl font-medium hover:bg-primary/90 transition-colors">
          {t('common.share')}
        </button>
      </div>

      {/* Disclaimer */}
      <div className="px-5 pb-4">
        <p className="text-xs text-muted-foreground text-center">
          {t('common.entertainment')}
        </p>
      </div>
    </div>
  );
};
