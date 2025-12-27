'use client';

import { useState } from 'react';
import { ProfileFormData } from '@/types';
import { createProfile } from '@/lib/api';
import { saveProfileId } from '@/lib/storage';
import LoadingSpinner from './LoadingSpinner';
import ErrorMessage from './ErrorMessage';
interface ProfileFormProps {
onSuccess: () => void;
}
export default function ProfileForm({ onSuccess }: ProfileFormProps) {
const [formData, setFormData] = useState<ProfileFormData>({
birthDate: '',
birthTime: '12:00',
birthTimeUnknown: false,
isLunar: false,
gender: '',
});
const [loading, setLoading] = useState(false);
const [error, setError] = useState<string | null>(null);
function handleChange(field: keyof ProfileFormData, value: any) {
setFormData(prev => ({
...prev,
[field]: value,
}));
}
async function handleSubmit(e: React.FormEvent) {
e.preventDefault();
// ?좏슚??寃??
if (!formData.birthDate) {
  setError('?앸뀈?붿씪???낅젰?댁＜?몄슂');
  return;
}

setLoading(true);
setError(null);

try {
  const response = await createProfile(formData);
  
  if (response.success && response.data) {
    // ?꾨줈??ID ???
    saveProfileId(response.data.id);
    
    // ?깃났 肄쒕갚
    onSuccess();
  } else {
    setError(response.error?.message || '?꾨줈???앹꽦???ㅽ뙣?덉뒿?덈떎');
  }
} catch (err) {
  setError('?????녿뒗 ?ㅻ쪟媛 諛쒖깮?덉뒿?덈떎');
} finally {
  setLoading(false);
}
}
if (loading) {
return (
<div className="card">
<LoadingSpinner message="?꾨줈?????以?.." />
</div>
);
}
return (
<form onSubmit={handleSubmit} className="space-y-6">
{error && <ErrorMessage message={error} />}
  <div className="card space-y-5">
    {/* ?앸뀈?붿씪 */}
    <div>
      <label className="label">
        ?앸뀈?붿씪 <span className="text-red-500">*</span>
      </label>
      <input
        type="date"
        value={formData.birthDate}
        onChange={(e) => handleChange('birthDate', e.target.value)}
        className="input-field"
        max={new Date().toISOString().split('T')[0]}
        required
      />
    </div>

    {/* ?묐젰/?뚮젰 */}
    <div>
      <label className="label">?щ젰 醫낅쪟</label>
      <div className="flex space-x-4">
        <label className="flex items-center space-x-2 cursor-pointer">
          <input
            type="radio"
            checked={!formData.isLunar}
            onChange={() => handleChange('isLunar', false)}
            className="w-4 h-4"
          />
          <span className="text-sm">?묐젰</span>
        </label>
        <label className="flex items-center space-x-2 cursor-pointer">
          <input
            type="radio"
            checked={formData.isLunar}
            onChange={() => handleChange('isLunar', true)}
            className="w-4 h-4"
          />
          <span className="text-sm">?뚮젰</span>
        </label>
      </div>
    </div>

    {/* ?쒖뼱???쒓컙 */}
    <div>
      <label className="label">?쒖뼱???쒓컙 (?좏깮)</label>
      <input
        type="time"
        value={formData.birthTime}
        onChange={(e) => handleChange('birthTime', e.target.value)}
        className="input-field"
        disabled={formData.birthTimeUnknown}
      />
      <label className="flex items-center space-x-2 mt-2 cursor-pointer">
        <input
          type="checkbox"
          checked={formData.birthTimeUnknown}
          onChange={(e) => handleChange('birthTimeUnknown', e.target.checked)}
          className="w-4 h-4"
        />
        <span className="text-sm text-gray-600">?쒓컙??紐⑤쫭?덈떎</span>
      </label>
    </div>

    {/* ?깅퀎 */}
    <div>
      <label className="label">?깅퀎 (?좏깮)</label>
      <div className="flex space-x-4">
        <label className="flex items-center space-x-2 cursor-pointer">
          <input
            type="radio"
            checked={formData.gender === 'male'}
            onChange={() => handleChange('gender', 'male')}
            className="w-4 h-4"
          />
          <span className="text-sm">?⑥꽦</span>
        </label>
        <label className="flex items-center space-x-2 cursor-pointer">
          <input
            type="radio"
            checked={formData.gender === 'female'}
            onChange={() => handleChange('gender', 'female')}
            className="w-4 h-4"
          />
          <span className="text-sm">?ъ꽦</span>
        </label>
        <label className="flex items-center space-x-2 cursor-pointer">
          <input
            type="radio"
            checked={formData.gender === ''}
            onChange={() => handleChange('gender', '')}
            className="w-4 h-4"
          />
          <span className="text-sm">?좏깮 ????/span>
        </label>
      </div>
    </div>
  </div>

  {/* ?쒖텧 踰꾪듉 */}
  <button type="submit" className="w-full btn-primary" disabled={loading}>
    {loading ? '???以?..' : '??ν븯怨?怨꾩냽?섍린'}
  </button>
</form>
);
}
