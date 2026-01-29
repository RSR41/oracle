import React from 'react';
import { motion } from 'motion/react';
import { ChevronRight } from 'lucide-react';

interface OracleCardProps {
  title: string;
  description?: string;
  icon?: React.ReactNode;
  badge?: string;
  accentColor?: string;
  onClick?: () => void;
  children?: React.ReactNode;
  className?: string;
}

export const OracleCard: React.FC<OracleCardProps> = ({
  title,
  description,
  icon,
  badge,
  accentColor = 'bg-primary',
  onClick,
  children,
  className = '',
}) => {
  const Component = onClick ? motion.button : motion.div;

  return (
    <Component
      whileTap={onClick ? { scale: 0.98 } : undefined}
      onClick={onClick}
      className={`
        bg-card rounded-2xl p-5 shadow-sm border border-border
        ${onClick ? 'cursor-pointer hover:shadow-md transition-shadow' : ''}
        ${className}
      `}
    >
      <div className="flex items-start justify-between mb-3">
        <div className="flex items-center gap-3">
          {icon && (
            <div className={`${accentColor} p-2.5 rounded-xl`}>
              {icon}
            </div>
          )}
          <div className="flex-1">
            <div className="flex items-center gap-2">
              <h3 className="font-semibold text-foreground">{title}</h3>
              {badge && (
                <span className="text-xs px-2 py-0.5 bg-primary/10 text-primary rounded-full">
                  {badge}
                </span>
              )}
            </div>
            {description && (
              <p className="text-sm text-muted-foreground mt-1">{description}</p>
            )}
          </div>
        </div>
        {onClick && (
          <ChevronRight className="text-muted-foreground flex-shrink-0" size={20} />
        )}
      </div>
      {children}
    </Component>
  );
};
