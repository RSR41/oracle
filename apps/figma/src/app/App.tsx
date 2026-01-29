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
    setScreenStack([...screenStack, { name: screen, data }]);
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
      
      // Placeholder screens for other features
      case 'fortune-today':
      case 'calendar':
      case 'saju-analysis':
      case 'consultation':
      case 'yearly-fortune':
      case 'compat-check':
      case 'compat-result':
      case 'profile-edit':
      case 'fortune-settings':
      case 'connection-settings':
      case 'premium':
        return (
          <div className="min-h-screen flex items-center justify-center px-5 pb-20">
            <div className="text-center">
              <div className="bg-primary/10 p-8 rounded-3xl mx-auto w-fit mb-6">
                <div className="text-5xl">🚧</div>
              </div>
              <h2 className="text-xl font-semibold text-foreground mb-2">준비 중입니다</h2>
              <p className="text-sm text-muted-foreground mb-6">
                이 기능은 곧 추가될 예정입니다
              </p>
              <button
                onClick={handleBack}
                className="px-6 py-3 bg-primary text-primary-foreground rounded-xl font-medium hover:bg-primary/90 transition-colors"
              >
                돌아가기
              </button>
            </div>
          </div>
        );
      
      default:
        return <Home onNavigate={handleNavigate} />;
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
    </AppProvider>
  );
}