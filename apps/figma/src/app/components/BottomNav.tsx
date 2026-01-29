import React from 'react';
import { Home, Sparkles, Heart, History, User } from 'lucide-react';
import { useApp } from '@/app/contexts/AppContext';

interface BottomNavProps {
  activeTab: string;
  onTabChange: (tab: string) => void;
}

export const BottomNav: React.FC<BottomNavProps> = ({ activeTab, onTabChange }) => {
  const { t } = useApp();

  const tabs = [
    { id: 'home', icon: Home, label: t('nav.home') },
    { id: 'fortune', icon: Sparkles, label: t('nav.fortune') },
    { id: 'compatibility', icon: Heart, label: t('nav.compatibility') },
    { id: 'history', icon: History, label: t('nav.history') },
    { id: 'profile', icon: User, label: t('nav.profile') },
  ];

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-card border-t border-border">
      <div className="max-w-md mx-auto flex items-center justify-around px-2 py-2">
        {tabs.map((tab) => {
          const Icon = tab.icon;
          const isActive = activeTab === tab.id;
          
          return (
            <button
              key={tab.id}
              onClick={() => onTabChange(tab.id)}
              className={`flex flex-col items-center justify-center min-w-[64px] py-2 px-3 rounded-xl transition-all ${
                isActive 
                  ? 'text-primary' 
                  : 'text-muted-foreground hover:text-foreground'
              }`}
            >
              <Icon 
                size={24} 
                strokeWidth={isActive ? 2.5 : 2}
                className="mb-1"
              />
              <span className="text-xs">{tab.label}</span>
            </button>
          );
        })}
      </div>
    </div>
  );
};
