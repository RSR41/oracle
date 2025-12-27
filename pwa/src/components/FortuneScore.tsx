import { FortuneScore as FortuneScoreType } from '@/types';
import { getFortuneScoreLabel, getFortuneScoreEmoji } from '@/lib/utils';
import { FORTUNE_SCORE_COLORS, FORTUNE_SCORE_BG_COLORS } from '@/lib/constants';

interface FortuneScoreProps {
  score: FortuneScoreType;
  size?: 'sm' | 'md' | 'lg';
  showLabel?: boolean;
}

export default function FortuneScore({ 
  score, 
  size = 'md',
  showLabel = true 
}: FortuneScoreProps) {
  const emoji = getFortuneScoreEmoji(score);
  const label = getFortuneScoreLabel(score);
  const colorClass = FORTUNE_SCORE_COLORS[score];
  const bgColorClass = FORTUNE_SCORE_BG_COLORS[score];

  const sizeClasses = {
    sm: 'text-sm px-3 py-1',
    md: 'text-base px-4 py-2',
    lg: 'text-lg px-6 py-3',
  };

  const emojiSizes = {
    sm: 'text-base',
    md: 'text-xl',
    lg: 'text-2xl',
  };

  return (
    <div className={`inline-flex items-center space-x-2 ${sizeClasses[size]} rounded-full ${bgColorClass} bg-opacity-10`}>
      <span className={emojiSizes[size]}>{emoji}</span>
      {showLabel && (
        <span className={`font-semibold ${colorClass}`}>
          {label}
        </span>
      )}
    </div>
  );
}
