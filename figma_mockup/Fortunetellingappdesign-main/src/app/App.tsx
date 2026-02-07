import React, { useState } from 'react';
import { AppProvider } from '@/app/contexts/AppContext';
import { BottomNav } from '@/app/components/BottomNav';
import { Onboarding } from '@/app/screens/Onboarding';
import { Home } from '@/app/screens/Home';
import { Fortune } from '@/app/screens/Fortune';
import { Compatibility } from '@/app/screens/Compatibility';
import { History } from '@/app/screens/History';
import { Profile } from '@/app/screens/Profile';
import { FaceReading } from '@/app/screens/FaceReading';
import { IdealType } from '@/app/screens/IdealType';
import { Connection } from '@/app/screens/Connection';
import { Settings } from '@/app/screens/Settings';
import { Tarot } from '@/app/screens/Tarot';
import { Dream } from '@/app/screens/Dream';
import { Chat } from '@/app/screens/Chat';
import { FortuneToday } from '@/app/screens/FortuneToday';
import { CalendarScreen } from '@/app/screens/Calendar';
import { CompatCheck } from '@/app/screens/CompatCheck';
import { CompatResult } from '@/app/screens/CompatResult';
import { Consultation } from '@/app/screens/Consultation';
import { ProfileEdit } from '@/app/screens/ProfileEdit';
import { Premium } from '@/app/screens/Premium';
import { FortuneDetail } from '@/app/screens/FortuneDetail';
import { CompatDetail } from '@/app/screens/CompatDetail';
import { TarotDetail } from '@/app/screens/TarotDetail';
import { DreamDetail } from '@/app/screens/DreamDetail';
import { FaceDetail } from '@/app/screens/FaceDetail';
import { PlaceholderScreen } from '@/app/components/PlaceholderScreen';
import { Toaster } from '@/app/components/ui/sonner';

type Screen = {
  name: string;
  data?: any;
};

export default function App() {
  const [showOnboarding, setShowOnboarding] = useState(true);
  const [activeTab, setActiveTab] = useState('home');
  const [screenStack, setScreenStack] = useState<Screen[]>([{ name: 'home' }]);

  const currentScreen = screenStack[screenStack.length - 1];

  const handleNavigate = (screen: string, data?: any) => {
    // Tab routes: auto-sync to tab instead of pushing
    const tabRoutes = ['home', 'fortune', 'compatibility', 'history', 'profile'];
    
    if (tabRoutes.includes(screen)) {
      handleTabChange(screen);
      // If data is provided, keep it in the stack
      if (data) {
        setScreenStack([{ name: screen, data }]);
      }
    } else {
      setScreenStack([...screenStack, { name: screen, data }]);
    }
  };

  const handleBack = () => {
    if (screenStack.length > 1) {
      setScreenStack(screenStack.slice(0, -1));
      
      // Update active tab if going back to a tab screen
      const previousScreen = screenStack[screenStack.length - 2];
      if (['home', 'fortune', 'compatibility', 'history', 'profile'].includes(previousScreen.name)) {
        setActiveTab(previousScreen.name);
      }
    }
  };

  const handleTabChange = (tab: string) => {
    setActiveTab(tab);
    setScreenStack([{ name: tab }]);
  };

  const renderScreen = () => {
    const { name, data } = currentScreen;

    switch (name) {
      case 'home':
        return <Home onNavigate={handleNavigate} />;
      
      case 'fortune':
        return <Fortune onNavigate={handleNavigate} />;
      
      case 'compatibility':
        return <Compatibility onNavigate={handleNavigate} />;
      
      case 'history':
        return <History onNavigate={handleNavigate} />;
      
      case 'profile':
        return <Profile onNavigate={handleNavigate} />;
      
      case 'face':
        return <FaceReading onNavigate={handleNavigate} onBack={handleBack} />;
      
      case 'ideal-type':
        return <IdealType onBack={handleBack} data={data} />;
      
      case 'connection':
        return <Connection onBack={handleBack} onNavigate={handleNavigate} />;
      
      case 'settings':
        return <Settings onBack={handleBack} />;
      
      case 'tarot':
        return <Tarot onBack={handleBack} />;
      
      case 'dream':
        return <Dream onBack={handleBack} />;
      
      case 'chat':
        return <Chat onBack={handleBack} />;
      
      // Feature screens
      case 'fortune-today':
        return <FortuneToday onBack={handleBack} />;
      
      case 'calendar':
        return <CalendarScreen onBack={handleBack} />;
      
      case 'compat-check':
        return <CompatCheck onBack={handleBack} onNavigate={handleNavigate} data={data} />;
      
      case 'compat-result':
        return <CompatResult onBack={handleBack} data={data} />;
      
      case 'consultation':
        return <Consultation onBack={handleBack} />;
      
      case 'profile-edit':
        return <ProfileEdit onBack={handleBack} />;
      
      case 'premium':
        return <Premium onBack={handleBack} />;
      
      // Placeholder screens with specific titles
      case 'saju-analysis':
        return <PlaceholderScreen onBack={handleBack} title="사주 분석" icon="📊" />;
      
      case 'yearly-fortune':
        return <PlaceholderScreen onBack={handleBack} title="2026년 신년운세" icon="🎊" />;
      
      case 'fortune-settings':
        return <PlaceholderScreen onBack={handleBack} title="운세 설정" icon="⚙️" />;
      
      case 'connection-settings':
        return <PlaceholderScreen onBack={handleBack} title="인연 기능 설정" icon="🔧" />;
      
      // History detail screens
      case 'fortune-detail':
        return <FortuneDetail onBack={handleBack} data={data} />;
      
      case 'compat-detail':
        return <CompatDetail onBack={handleBack} data={data} />;
      
      case 'tarot-detail':
        return <TarotDetail onBack={handleBack} data={data} />;
      
      case 'dream-detail':
        return <DreamDetail onBack={handleBack} data={data} />;
      
      case 'face-detail':
        return <FaceDetail onBack={handleBack} data={data} />;
      
      default:
        return <PlaceholderScreen onBack={handleBack} title="준비 중" />;
    }
  };

  return (
    <AppProvider>
      <div className="min-h-screen bg-background">
        {/* Main Content */}
        <div className="max-w-md mx-auto min-h-screen bg-background relative">
          {showOnboarding ? (
            <Onboarding onComplete={() => setShowOnboarding(false)} />
          ) : (
            <>
              {renderScreen()}
              
              {/* Show bottom nav only on main tab screens */}
              {['home', 'fortune', 'compatibility', 'history', 'profile'].includes(currentScreen.name) && (
                <BottomNav activeTab={activeTab} onTabChange={handleTabChange} />
              )}
            </>
          )}
        </div>
      </div>
      <Toaster />
    </AppProvider>
  );
}