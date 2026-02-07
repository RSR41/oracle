import React from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { Settings as SettingsIcon, User, Calendar, Heart, Crown, ChevronRight } from 'lucide-react';
import { motion } from 'motion/react';

interface ProfileProps {
  onNavigate: (screen: string) => void;
}

export const Profile: React.FC<ProfileProps> = ({ onNavigate }) => {
  const { t } = useApp();

  // Mock user data
  const userData = {
    name: '김지은',
    birthDate: '1995.03.15',
    zodiac: '토끼띠',
    element: '목(木)',
    isPremium: false,
  };

  const menuItems = [
    {
      icon: User,
      label: '내 프로필',
      description: '생년월일 및 사주 정보',
      screen: 'profile-edit',
      color: 'bg-primary',
    },
    {
      icon: Calendar,
      label: '내 운세 관리',
      description: '맞춤 운세 알림 설정',
      screen: 'fortune-settings',
      color: 'bg-[#9DB4A0]',
    },
    {
      icon: Heart,
      label: '인연 기능',
      description: '매칭 및 추천 설정',
      screen: 'connection-settings',
      color: 'bg-[#E9C5B5]',
      badge: 'Beta',
    },
    {
      icon: Crown,
      label: '프리미엄',
      description: '더 많은 기능 이용하기',
      screen: 'premium',
      color: 'bg-[#C4A574]',
      badge: 'New',
    },
  ];

  return (
    <div className="pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4 flex items-center justify-between">
        <h1 className="text-2xl font-semibold text-foreground">{t('nav.profile')}</h1>
        <button 
          onClick={() => onNavigate('settings')}
          className="p-2 hover:bg-secondary rounded-xl transition-colors"
        >
          <SettingsIcon size={24} className="text-foreground" />
        </button>
      </div>

      {/* User Card */}
      <div className="px-5 mb-6">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-gradient-to-br from-primary to-[#C4A574] rounded-3xl p-6 shadow-lg"
        >
          <div className="flex items-start gap-4 mb-4">
            <div className="w-16 h-16 rounded-full bg-white/20 backdrop-blur-sm flex items-center justify-center">
              <User className="text-white" size={32} />
            </div>
            <div className="flex-1">
              <h2 className="text-white text-xl font-bold mb-1">{userData.name}</h2>
              <p className="text-white/80 text-sm">{userData.birthDate}</p>
            </div>
            {!userData.isPremium && (
              <button
                onClick={() => onNavigate('premium')}
                className="bg-white/20 hover:bg-white/30 backdrop-blur-sm px-4 py-2 rounded-xl transition-colors"
              >
                <span className="text-white text-sm font-medium">프리미엄</span>
              </button>
            )}
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div className="bg-white/10 rounded-xl p-3 backdrop-blur-sm">
              <div className="text-white/80 text-xs mb-1">띠</div>
              <div className="text-white font-semibold">{userData.zodiac}</div>
            </div>
            <div className="bg-white/10 rounded-xl p-3 backdrop-blur-sm">
              <div className="text-white/80 text-xs mb-1">오행</div>
              <div className="text-white font-semibold">{userData.element}</div>
            </div>
          </div>
        </motion.div>
      </div>

      {/* Menu Items */}
      <div className="px-5 mb-6 space-y-3">
        {menuItems.map((item, idx) => {
          const Icon = item.icon;
          
          return (
            <motion.button
              key={idx}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: idx * 0.05 }}
              onClick={() => onNavigate(item.screen)}
              className="w-full bg-card rounded-2xl p-4 shadow-sm border border-border hover:shadow-md transition-all text-left"
            >
              <div className="flex items-center gap-4">
                <div className={`${item.color} p-3 rounded-xl`}>
                  <Icon className="text-white" size={24} />
                </div>
                <div className="flex-1">
                  <div className="flex items-center gap-2 mb-1">
                    <h3 className="font-semibold text-foreground">{item.label}</h3>
                    {item.badge && (
                      <span className="text-xs px-2 py-0.5 bg-primary/10 text-primary rounded-full">
                        {item.badge}
                      </span>
                    )}
                  </div>
                  <p className="text-sm text-muted-foreground">{item.description}</p>
                </div>
                <ChevronRight className="text-muted-foreground flex-shrink-0" size={20} />
              </div>
            </motion.button>
          );
        })}
      </div>

      {/* Quick Stats */}
      <div className="px-5 mb-6">
        <div className="bg-secondary rounded-2xl p-5">
          <h3 className="font-semibold text-foreground mb-4">이번 주 활동</h3>
          <div className="grid grid-cols-3 gap-4">
            <div className="text-center">
              <div className="text-2xl font-bold text-primary mb-1">8</div>
              <div className="text-xs text-muted-foreground">운세 확인</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-primary mb-1">3</div>
              <div className="text-xs text-muted-foreground">궁합 확인</div>
            </div>
            <div className="text-center">
              <div className="text-2xl font-bold text-primary mb-1">2</div>
              <div className="text-xs text-muted-foreground">저장된 결과</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
