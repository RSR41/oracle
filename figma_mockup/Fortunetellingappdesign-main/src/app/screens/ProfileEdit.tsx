import React, { useState } from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { ArrowLeft, User, Calendar } from 'lucide-react';

interface ProfileEditProps {
  onBack: () => void;
}

export const ProfileEdit: React.FC<ProfileEditProps> = ({ onBack }) => {
  const { t } = useApp();
  
  const [formData, setFormData] = useState({
    name: '김지은',
    birthYear: '1995',
    birthMonth: '03',
    birthDay: '15',
    birthHour: '09-11',
    gender: 'female',
  });

  return (
    <div className="min-h-screen pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4 flex items-center gap-3">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
          <ArrowLeft size={24} className="text-foreground" />
        </button>
        <div>
          <h1 className="text-2xl font-semibold text-foreground">프로필 수정</h1>
        </div>
      </div>

      {/* Form */}
      <div className="px-5 mb-6 space-y-5">
        <div>
          <label className="block text-sm font-semibold text-foreground mb-2">이름</label>
          <input
            type="text"
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
            className="w-full px-4 py-3 bg-card border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/20 text-foreground"
          />
        </div>

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

        <div>
          <label className="block text-sm font-semibold text-foreground mb-2">생년월일</label>
          <div className="grid grid-cols-3 gap-3">
            <input
              type="number"
              value={formData.birthYear}
              onChange={(e) => setFormData({ ...formData, birthYear: e.target.value })}
              placeholder="1990"
              className="px-4 py-3 bg-card border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/20 text-foreground"
            />
            <input
              type="number"
              value={formData.birthMonth}
              onChange={(e) => setFormData({ ...formData, birthMonth: e.target.value })}
              placeholder="03"
              className="px-4 py-3 bg-card border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/20 text-foreground"
            />
            <input
              type="number"
              value={formData.birthDay}
              onChange={(e) => setFormData({ ...formData, birthDay: e.target.value })}
              placeholder="15"
              className="px-4 py-3 bg-card border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/20 text-foreground"
            />
          </div>
        </div>

        <div>
          <label className="block text-sm font-semibold text-foreground mb-2">태어난 시간</label>
          <select
            value={formData.birthHour}
            onChange={(e) => setFormData({ ...formData, birthHour: e.target.value })}
            className="w-full px-4 py-3 bg-card border border-border rounded-xl focus:outline-none focus:ring-2 focus:ring-primary/20 text-foreground"
          >
            <option value="">모름</option>
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

      {/* Save Button */}
      <div className="px-5">
        <button className="w-full bg-primary text-primary-foreground py-4 rounded-2xl font-semibold hover:bg-primary/90 transition-colors">
          저장하기
        </button>
      </div>
    </div>
  );
};
