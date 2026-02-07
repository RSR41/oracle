import React, { useState } from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { Scan, Upload, Camera, Sparkles, ArrowLeft } from 'lucide-react';
import { motion } from 'motion/react';

interface FaceReadingProps {
  onNavigate: (screen: string, data?: any) => void;
  onBack: () => void;
}

export const FaceReading: React.FC<FaceReadingProps> = ({ onNavigate, onBack }) => {
  const { t } = useApp();
  const [step, setStep] = useState<'upload' | 'analyzing' | 'result'>('upload');
  const [analysisResult, setAnalysisResult] = useState<any>(null);

  const handleUpload = () => {
    setStep('analyzing');
    
    // Simulate analysis
    setTimeout(() => {
      setAnalysisResult({
        personality: '따뜻하고 배려심 많은 성격',
        strength: '친화력이 뛰어나고 공감 능력이 높음',
        attention: '가끔 타인을 너무 배려하다 본인을 잃을 수 있음',
        relationships: '좋은 관계를 오래 유지하는 편',
        loveStyle: '헌신적이고 진심을 다하는 연애',
        compatibility: 85,
      });
      setStep('result');
    }, 2000);
  };

  if (step === 'upload') {
    return (
      <div className="min-h-screen pb-20">
        {/* Header */}
        <div className="px-5 pt-6 pb-4 flex items-center gap-3">
          <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
            <ArrowLeft size={24} className="text-foreground" />
          </button>
          <div>
            <h1 className="text-2xl font-semibold text-foreground">{t('face.title')}</h1>
          </div>
        </div>

        {/* Consent */}
        <div className="px-5 mb-6">
          <div className="bg-primary/5 border border-primary/20 rounded-2xl p-5">
            <div className="flex items-start gap-3">
              <div className="bg-primary/10 p-2 rounded-lg">
                <Sparkles className="text-primary" size={20} />
              </div>
              <div className="flex-1">
                <h3 className="font-semibold text-foreground mb-2">안내사항</h3>
                <ul className="text-sm text-muted-foreground space-y-1.5">
                  <li>• AI가 얼굴을 분석하여 성향을 파악합니다</li>
                  <li>• 업로드된 사진은 분석 후 즉시 삭제됩니다</li>
                  <li>• 결과는 참고용이며 실제와 다를 수 있습니다</li>
                  <li>• 타인의 사진은 사용하지 마세요</li>
                </ul>
              </div>
            </div>
          </div>
        </div>

        {/* Upload Area */}
        <div className="px-5 mb-6">
          <div className="aspect-[3/4] bg-secondary rounded-3xl border-2 border-dashed border-border flex flex-col items-center justify-center p-8">
            <div className="bg-primary/10 p-6 rounded-2xl mb-4">
              <Scan className="text-primary" size={48} />
            </div>
            <h3 className="text-lg font-semibold text-foreground mb-2">
              {t('face.upload')}
            </h3>
            <p className="text-sm text-muted-foreground text-center mb-6">
              정면을 바라보는 선명한 사진을 선택해주세요
            </p>
            <div className="flex gap-3">
              <button
                onClick={handleUpload}
                className="px-6 py-3 bg-card border border-border rounded-xl flex items-center gap-2 hover:shadow-md transition-all"
              >
                <Camera size={20} className="text-foreground" />
                <span className="text-sm font-medium text-foreground">촬영하기</span>
              </button>
              <button
                onClick={handleUpload}
                className="px-6 py-3 bg-primary text-primary-foreground rounded-xl flex items-center gap-2 hover:bg-primary/90 transition-colors"
              >
                <Upload size={20} />
                <span className="text-sm font-medium">갤러리</span>
              </button>
            </div>
          </div>
        </div>

        {/* Info */}
        <div className="px-5">
          <p className="text-xs text-muted-foreground text-center">
            {t('common.entertainment')}
          </p>
        </div>
      </div>
    );
  }

  if (step === 'analyzing') {
    return (
      <div className="min-h-screen flex items-center justify-center px-5 pb-20">
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          className="text-center"
        >
          <motion.div
            animate={{ rotate: 360 }}
            transition={{ duration: 2, repeat: Infinity, ease: "linear" }}
            className="bg-primary/10 p-8 rounded-3xl mx-auto w-fit mb-6"
          >
            <Scan className="text-primary" size={64} />
          </motion.div>
          <h2 className="text-xl font-semibold text-foreground mb-2">분석 중...</h2>
          <p className="text-sm text-muted-foreground">
            AI가 얼굴을 분석하고 있습니다
          </p>
        </motion.div>
      </div>
    );
  }

  return (
    <div className="pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4 flex items-center gap-3">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
          <ArrowLeft size={24} className="text-foreground" />
        </button>
        <div>
          <h1 className="text-2xl font-semibold text-foreground">{t('face.result')}</h1>
        </div>
      </div>

      {/* Result Card */}
      <div className="px-5 mb-6">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-gradient-to-br from-primary to-[#C4A574] rounded-3xl p-6 shadow-lg"
        >
          <div className="flex items-center justify-between mb-4">
            <span className="text-white text-lg font-semibold">분석 완료</span>
            <div className="bg-white/20 p-2.5 rounded-xl backdrop-blur-sm">
              <Sparkles className="text-white" size={20} />
            </div>
          </div>
          <div className="bg-white/10 rounded-2xl p-4 backdrop-blur-sm">
            <div className="text-white/90 text-sm mb-2">종합 점수</div>
            <div className="text-white text-4xl font-bold">{analysisResult?.compatibility}</div>
          </div>
        </motion.div>
      </div>

      {/* Analysis Details */}
      <div className="px-5 mb-6 space-y-4">
        {[
          { label: '성격', value: analysisResult?.personality, icon: '🌟' },
          { label: '강점', value: analysisResult?.strength, icon: '💪' },
          { label: '주의점', value: analysisResult?.attention, icon: '⚠️' },
          { label: '대인관계', value: analysisResult?.relationships, icon: '👥' },
          { label: '연애 스타일', value: analysisResult?.loveStyle, icon: '💕' },
        ].map((item, idx) => (
          <motion.div
            key={idx}
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: idx * 0.1 }}
            className="bg-card rounded-2xl p-5 shadow-sm border border-border"
          >
            <div className="flex items-start gap-3">
              <span className="text-2xl">{item.icon}</span>
              <div className="flex-1">
                <h3 className="font-semibold text-foreground mb-1">{item.label}</h3>
                <p className="text-sm text-muted-foreground">{item.value}</p>
              </div>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Ideal Type Generation CTA */}
      <div className="px-5 mb-6">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
          className="bg-gradient-to-br from-[#E9C5B5]/20 to-transparent rounded-2xl p-5 border border-[#E9C5B5]/30"
        >
          <div className="flex items-start gap-3 mb-4">
            <div className="bg-[#E9C5B5] p-2.5 rounded-xl">
              <Sparkles className="text-white" size={20} />
            </div>
            <div>
              <div className="font-semibold text-foreground mb-1">
                {t('face.idealType')}
              </div>
              <div className="text-sm text-muted-foreground">
                관상 결과를 바탕으로 이상형을 생성해보세요
              </div>
            </div>
          </div>
          <button
            onClick={() => onNavigate('ideal-type', { faceData: analysisResult })}
            className="w-full bg-[#E9C5B5] hover:bg-[#D9B5A5] text-white py-2.5 rounded-xl text-sm font-medium transition-colors"
          >
            {t('face.generateIdeal')} →
          </button>
        </motion.div>
      </div>

      {/* Actions */}
      <div className="px-5 mb-6 flex gap-3">
        <button className="flex-1 py-3 bg-card border border-border rounded-xl text-sm font-medium hover:bg-secondary transition-colors">
          {t('common.save')}
        </button>
        <button className="flex-1 py-3 bg-primary text-primary-foreground rounded-xl text-sm font-medium hover:bg-primary/90 transition-colors">
          {t('common.share')}
        </button>
      </div>
    </div>
  );
};
