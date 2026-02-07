import React, { useState } from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { ArrowLeft, Heart } from 'lucide-react';
import { motion } from 'motion/react';

interface CompatCheckProps {
  onBack: () => void;
  onNavigate: (screen: string, data?: any) => void;
  data?: { type: 'love' | 'friend' | 'business' };
}

export const CompatCheck: React.FC<CompatCheckProps> = ({ onBack, onNavigate, data }) => {
  const { t } = useApp();
  const compatType = data?.type || 'love';
  
  const [formData, setFormData] = useState({
    name: '',
    birthYear: '',
    birthMonth: '',
    birthDay: '',
    birthHour: '',
    gender: '',
  });

  const typeLabels = {
    love: '연애 궁합',
    friend: '친구 궁합',
    business: '비즈니스 궁합',
  };

  const typeColors = {
    love: 'from-[#E9C5B5] to-[#C4A574]',
    friend: 'from-[#9DB4A0] to-[#C4A574]',
    business: 'from-[#B8D4E8] to-[#9DB4A0]',
  };

  const handleSubmit = () => {
    if (formData.name && formData.birthYear && formData.birthMonth && formData.birthDay) {
      onNavigate('compat-result', { 
        type: compatType,
        partner: formData,
        score: Math.floor(Math.random() * 20) + 80
      });
    }
  };

  const isFormValid = formData.name && formData.birthYear && formData.birthMonth && formData.birthDay && formData.gender;

  return (
    <div className="min-h-screen pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4 flex items-center gap-3">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
          <ArrowLeft size={24} className="text-foreground" />
        </button>
        <div>
          <h1 className="text-2xl font-semibold text-foreground">{typeLabels[compatType]}</h1>
          <p className="text-sm text-muted-foreground">상대방 정보 입력</p>
        </div>
      </div>

      {/* Info */}
      <div className="px-5 mb-6">
        <div className={`bg-gradient-to-r ${typeColors[compatType]} rounded-2xl p-5 shadow-lg`}>
          <div className="flex items-center gap-3 mb-3">
            <div className="bg-white/20 p-2.5 rounded-xl backdrop-blur-sm">
              <Heart className="text-white" size={20} />
            </div>
            <div>
              <div className="text-white font-semibold">{typeLabels[compatType]} 보기</div>
              <div className="text-white/80 text-sm">정확한 사주 정보를 입력해주세요</div>
            </div>
          </div>
        </div>
      </div>

      {/* Form */}
      <div className="px-5 mb-6 space-y-5">
        {/* Name */}
        <div>
          <label className="block text-sm font-semibold text-foreground mb-2">이름</label>
          <input
            type="text"
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
            placeholder="상대방 이름을 입력하세요"
            className="w-full px-4 py-3 bg-card border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/20 text-foreground placeholder:text-muted-foreground"
          />
        </div>

        {/* Gender */}
        <div>
          <label className="block text-sm font-semibold text-foreground mb-2">성별</label>
          <div className="grid grid-cols-2 gap-3">
            {[
              { value: 'male', label: '남성', emoji: '👨' },
              { value: 'female', label: '여성', emoji: '👩' },
            ].map((option) => (
              <button
                key={option.value}
                onClick={() => setFormData({ ...formData, gender: option.value })}
                className={`p-4 rounded-xl border-2 transition-all ${
                  formData.gender === option.value
                    ? 'border-primary bg-primary/5'
                    : 'border-border bg-card hover:border-primary/50'
                }`}
              >
                <div className="text-2xl mb-1">{option.emoji}</div>
                <div className={`text-sm font-medium ${
                  formData.gender === option.value ? 'text-primary' : 'text-foreground'
                }`}>
                  {option.label}
                </div>
              </button>
            ))}
          </div>
        </div>

        {/* Birth Date */}
        <div>
          <label className="block text-sm font-semibold text-foreground mb-2">생년월일</label>
          <div className="grid grid-cols-3 gap-3">
            <input
              type="number"
              value={formData.birthYear}
              onChange={(e) => setFormData({ ...formData, birthYear: e.target.value })}
              placeholder="1990"
              className="px-4 py-3 bg-card border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/20 text-foreground placeholder:text-muted-foreground"
            />
            <input
              type="number"
              value={formData.birthMonth}
              onChange={(e) => setFormData({ ...formData, birthMonth: e.target.value })}
              placeholder="03"
              className="px-4 py-3 bg-card border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/20 text-foreground placeholder:text-muted-foreground"
            />
            <input
              type="number"
              value={formData.birthDay}
              onChange={(e) => setFormData({ ...formData, birthDay: e.target.value })}
              placeholder="15"
              className="px-4 py-3 bg-card border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/20 text-foreground placeholder:text-muted-foreground"
            />
          </div>
        </div>

        {/* Birth Time (Optional) */}
        <div>
          <label className="block text-sm font-semibold text-foreground mb-2">
            태어난 시간 <span className="text-muted-foreground font-normal">(선택)</span>
          </label>
          <select
            value={formData.birthHour}
            onChange={(e) => setFormData({ ...formData, birthHour: e.target.value })}
            className="w-full px-4 py-3 bg-card border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/20 text-foreground"
          >
            <option value="">모름/선택 안함</option>
            <option value="23-01">자시 (23:00-01:00)</option>
            <option value="01-03">축시 (01:00-03:00)</option>
            <option value="03-05">인시 (03:00-05:00)</option>
            <option value="05-07">묘시 (05:00-07:00)</option>
            <option value="07-09">진시 (07:00-09:00)</option>
            <option value="09-11">사시 (09:00-11:00)</option>
            <option value="11-13">오시 (11:00-13:00)</option>
            <option value="13-15">미시 (13:00-15:00)</option>
            <option value="15-17">신시 (15:00-17:00)</option>
            <option value="17-19">유시 (17:00-19:00)</option>
            <option value="19-21">술시 (19:00-21:00)</option>
            <option value="21-23">해시 (21:00-23:00)</option>
          </select>
        </div>
      </div>

      {/* Info Notice */}
      <div className="px-5 mb-6">
        <div className="bg-secondary rounded-2xl p-4">
          <p className="text-xs text-muted-foreground leading-relaxed">
            • 정확한 생년월일을 입력할수록 더 정확한 궁합 결과를 받을 수 있습니다<br />
            • 태어난 시간을 모르는 경우 선택하지 않아도 됩니다<br />
            • 입력하신 정보는 안전하게 보호되며 궁합 확인 후 저장되지 않습니다
          </p>
        </div>
      </div>

      {/* Submit Button */}
      <div className="px-5">
        <button
          onClick={handleSubmit}
          disabled={!isFormValid}
          className={`w-full bg-gradient-to-r ${typeColors[compatType]} text-white py-4 rounded-2xl font-semibold shadow-lg hover:shadow-xl transition-all disabled:opacity-50 disabled:cursor-not-allowed`}
        >
          궁합 확인하기
        </button>
      </div>
    </div>
  );
};
