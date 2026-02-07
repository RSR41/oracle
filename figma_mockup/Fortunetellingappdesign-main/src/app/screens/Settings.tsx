import React, { useState } from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { OracleCard } from '@/app/components/OracleCard';
import { 
  Sun, 
  Moon, 
  Monitor, 
  Globe, 
  Bell, 
  Shield, 
  Trash2,
  Users,
  ChevronRight,
  ArrowLeft
} from 'lucide-react';
import { motion } from 'motion/react';
import { 
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from '@/app/components/ui/alert-dialog';
import { toast } from 'sonner';

interface SettingsProps {
  onBack: () => void;
}

export const Settings: React.FC<SettingsProps> = ({ onBack }) => {
  const { t, theme, setTheme, language, setLanguage, clearHistory } = useApp();
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);
  const [showNotificationInfo, setShowNotificationInfo] = useState(false);
  const [showPrivacyInfo, setShowPrivacyInfo] = useState(false);

  const themeOptions = [
    { id: 'light', label: t('settings.theme.light'), icon: Sun },
    { id: 'dark', label: t('settings.theme.dark'), icon: Moon },
    { id: 'system', label: t('settings.theme.system'), icon: Monitor },
  ];

  const languageOptions = [
    { id: 'ko', label: '한국어', flag: '🇰🇷' },
    { id: 'en', label: 'English', flag: '🇺🇸' },
  ];

  const handleDeleteData = () => {
    clearHistory();
    setShowDeleteConfirm(false);
    toast.success('모든 데이터가 삭제되었습니다');
  };

  return (
    <div className="pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4 flex items-center gap-3">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
          <ArrowLeft size={24} className="text-foreground" />
        </button>
        <h1 className="text-2xl font-semibold text-foreground">{t('settings.title')}</h1>
      </div>

      {/* Appearance */}
      <div className="px-5 mb-6">
        <h2 className="text-sm font-semibold text-muted-foreground mb-3 uppercase tracking-wide">
          {t('settings.appearance')}
        </h2>
        <div className="bg-card rounded-2xl shadow-sm border border-border overflow-hidden">
          {themeOptions.map((option, idx) => {
            const Icon = option.icon;
            const isSelected = theme === option.id;
            
            return (
              <motion.button
                key={option.id}
                whileTap={{ scale: 0.98 }}
                onClick={() => setTheme(option.id as any)}
                className={`w-full px-5 py-4 flex items-center justify-between transition-colors ${
                  idx !== 0 ? 'border-t border-border' : ''
                } ${isSelected ? 'bg-primary/5' : 'hover:bg-secondary'}`}
              >
                <div className="flex items-center gap-3">
                  <div className={`p-2 rounded-lg ${
                    isSelected ? 'bg-primary/10' : 'bg-secondary'
                  }`}>
                    <Icon 
                      className={isSelected ? 'text-primary' : 'text-foreground'} 
                      size={20} 
                    />
                  </div>
                  <span className={`font-medium ${
                    isSelected ? 'text-primary' : 'text-foreground'
                  }`}>
                    {option.label}
                  </span>
                </div>
                {isSelected && (
                  <div className="w-2 h-2 bg-primary rounded-full" />
                )}
              </motion.button>
            );
          })}
        </div>
      </div>

      {/* Language */}
      <div className="px-5 mb-6">
        <h2 className="text-sm font-semibold text-muted-foreground mb-3 uppercase tracking-wide">
          {t('settings.language')}
        </h2>
        <div className="bg-card rounded-2xl shadow-sm border border-border overflow-hidden">
          {languageOptions.map((option, idx) => {
            const isSelected = language === option.id;
            
            return (
              <motion.button
                key={option.id}
                whileTap={{ scale: 0.98 }}
                onClick={() => setLanguage(option.id as any)}
                className={`w-full px-5 py-4 flex items-center justify-between transition-colors ${
                  idx !== 0 ? 'border-t border-border' : ''
                } ${isSelected ? 'bg-primary/5' : 'hover:bg-secondary'}`}
              >
                <div className="flex items-center gap-3">
                  <span className="text-2xl">{option.flag}</span>
                  <span className={`font-medium ${
                    isSelected ? 'text-primary' : 'text-foreground'
                  }`}>
                    {option.label}
                  </span>
                </div>
                {isSelected && (
                  <div className="w-2 h-2 bg-primary rounded-full" />
                )}
              </motion.button>
            );
          })}
        </div>
      </div>

      {/* Notifications */}
      <div className="px-5 mb-6">
        <h2 className="text-sm font-semibold text-muted-foreground mb-3 uppercase tracking-wide">
          {t('settings.notifications')}
        </h2>
        <div className="bg-card rounded-2xl shadow-sm border border-border">
          <button className="w-full px-5 py-4 flex items-center justify-between hover:bg-secondary transition-colors">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-secondary rounded-lg">
                <Bell className="text-foreground" size={20} />
              </div>
              <span className="font-medium text-foreground">알림 설정</span>
            </div>
            <ChevronRight className="text-muted-foreground" size={20} />
          </button>
        </div>
      </div>

      {/* Privacy & Connection Feature */}
      <div className="px-5 mb-6">
        <h2 className="text-sm font-semibold text-muted-foreground mb-3 uppercase tracking-wide">
          {t('settings.privacy')}
        </h2>
        <div className="bg-card rounded-2xl shadow-sm border border-border overflow-hidden">
          <button className="w-full px-5 py-4 flex items-center justify-between hover:bg-secondary transition-colors">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-secondary rounded-lg">
                <Shield className="text-foreground" size={20} />
              </div>
              <span className="font-medium text-foreground">개인정보 보호</span>
            </div>
            <ChevronRight className="text-muted-foreground" size={20} />
          </button>
          
          <button className="w-full px-5 py-4 flex items-center justify-between hover:bg-secondary transition-colors border-t border-border">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-secondary rounded-lg">
                <Users className="text-foreground" size={20} />
              </div>
              <div className="flex-1 text-left">
                <div className="font-medium text-foreground">{t('settings.connectionFeature')}</div>
                <div className="text-xs text-muted-foreground mt-0.5">
                  인연 추천 기능 사용 설정
                </div>
              </div>
            </div>
            <ChevronRight className="text-muted-foreground" size={20} />
          </button>
          
          <button 
            onClick={() => setShowDeleteConfirm(true)}
            className="w-full px-5 py-4 flex items-center justify-between hover:bg-destructive/5 transition-colors border-t border-border"
          >
            <div className="flex items-center gap-3">
              <div className="p-2 bg-destructive/10 rounded-lg">
                <Trash2 className="text-destructive" size={20} />
              </div>
              <span className="font-medium text-destructive">{t('settings.deleteData')}</span>
            </div>
            <ChevronRight className="text-muted-foreground" size={20} />
          </button>
        </div>
      </div>

      {/* App Info */}
      <div className="px-5 pb-4">
        <div className="text-center space-y-1">
          <p className="text-sm text-muted-foreground">Oracle v1.0.0</p>
          <p className="text-xs text-muted-foreground">
            {t('common.entertainment')}
          </p>
        </div>
      </div>

      {/* Delete Confirmation Dialog */}
      <AlertDialog open={showDeleteConfirm} onOpenChange={setShowDeleteConfirm}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>데이터를 삭제하시겠습니까?</AlertDialogTitle>
            <AlertDialogDescription>
              저장된 모든 운세 기록이 삭제됩니다. 이 작업은 되돌릴 수 없습니다.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>취소</AlertDialogCancel>
            <AlertDialogAction onClick={handleDeleteData} className="bg-destructive text-destructive-foreground hover:bg-destructive/90">
              삭제
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
};