import React, { useState } from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { ArrowLeft, Star, MessageCircle, Clock, Award } from 'lucide-react';
import { motion } from 'motion/react';
import { ImageWithFallback } from '@/app/components/figma/ImageWithFallback';

interface ConsultationProps {
  onBack: () => void;
}

export const Consultation: React.FC<ConsultationProps> = ({ onBack }) => {
  const { t } = useApp();
  const [selectedCategory, setSelectedCategory] = useState<string>('all');

  const categories = [
    { id: 'all', label: '전체' },
    { id: 'fortune', label: '운세/사주' },
    { id: 'tarot', label: '타로' },
    { id: 'dream', label: '꿈해몽' },
    { id: 'love', label: '연애/궁합' },
  ];

  const consultants = [
    {
      id: 1,
      name: '김명운',
      title: '사주 명리학 전문가',
      category: 'fortune',
      rating: 4.9,
      reviews: 1250,
      experience: '20년',
      price: '30,000원',
      image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop',
      specialties: ['사주', '궁합', '이름'],
      isOnline: true,
    },
    {
      id: 2,
      name: '이해원',
      title: '타로 마스터',
      category: 'tarot',
      rating: 4.8,
      reviews: 980,
      experience: '15년',
      price: '25,000원',
      image: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200&h=200&fit=crop',
      specialties: ['타로', '꿈해몽', '연애운'],
      isOnline: true,
    },
    {
      id: 3,
      name: '박운세',
      title: '종합 운세 상담사',
      category: 'fortune',
      rating: 4.7,
      reviews: 765,
      experience: '12년',
      price: '28,000원',
      image: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop',
      specialties: ['사주', '관상', '풍수'],
      isOnline: false,
    },
    {
      id: 4,
      name: '정타로',
      title: '타로 & 오라클 전문',
      category: 'tarot',
      rating: 4.9,
      reviews: 1100,
      experience: '18년',
      price: '35,000원',
      image: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&h=200&fit=crop',
      specialties: ['타로', '오라클', '연애'],
      isOnline: true,
    },
  ];

  const filteredConsultants = selectedCategory === 'all'
    ? consultants
    : consultants.filter(c => c.category === selectedCategory);

  return (
    <div className="pb-20">
      {/* Header */}
      <div className="px-5 pt-6 pb-4 flex items-center gap-3">
        <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
          <ArrowLeft size={24} className="text-foreground" />
        </button>
        <div>
          <h1 className="text-2xl font-semibold text-foreground">전문 상담</h1>
          <p className="text-sm text-muted-foreground">1:1 맞춤 상담</p>
        </div>
      </div>

      {/* Info Banner */}
      <div className="px-5 mb-6">
        <div className="bg-primary/5 border border-primary/20 rounded-2xl p-5">
          <div className="flex items-start gap-3">
            <div className="bg-primary/10 p-2 rounded-lg">
              <MessageCircle className="text-primary" size={20} />
            </div>
            <div className="flex-1">
              <h3 className="font-semibold text-foreground mb-1">상담 안내</h3>
              <ul className="text-sm text-muted-foreground space-y-1">
                <li>• 경력 10년 이상의 검증된 전문가</li>
                <li>• 채팅 또는 음성 통화 선택 가능</li>
                <li>• 상담 내용은 안전하게 보호됩니다</li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      {/* Category Filter */}
      <div className="px-5 mb-6 overflow-x-auto">
        <div className="flex gap-2 pb-2">
          {categories.map((category) => (
            <button
              key={category.id}
              onClick={() => setSelectedCategory(category.id)}
              className={`px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap transition-colors ${
                selectedCategory === category.id
                  ? 'bg-primary text-primary-foreground'
                  : 'bg-secondary text-secondary-foreground hover:bg-primary/10'
              }`}
            >
              {category.label}
            </button>
          ))}
        </div>
      </div>

      {/* Consultants List */}
      <div className="px-5 space-y-4">
        {filteredConsultants.map((consultant, idx) => (
          <motion.div
            key={consultant.id}
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: idx * 0.05 }}
            className="bg-card rounded-2xl p-5 shadow-sm border border-border"
          >
            <div className="flex gap-4 mb-4">
              {/* Profile Image */}
              <div className="relative flex-shrink-0">
                <div className="w-20 h-20 rounded-full overflow-hidden">
                  <ImageWithFallback
                    src={consultant.image}
                    alt={consultant.name}
                    className="w-full h-full object-cover"
                  />
                </div>
                {consultant.isOnline && (
                  <div className="absolute bottom-0 right-0 w-4 h-4 bg-green-500 border-2 border-card rounded-full" />
                )}
              </div>

              {/* Info */}
              <div className="flex-1 min-w-0">
                <div className="flex items-start justify-between mb-2">
                  <div>
                    <h3 className="font-semibold text-foreground text-lg">{consultant.name}</h3>
                    <p className="text-sm text-muted-foreground">{consultant.title}</p>
                  </div>
                  <div className="text-right">
                    <div className="text-lg font-bold text-primary">{consultant.price}</div>
                    <div className="text-xs text-muted-foreground">30분 기준</div>
                  </div>
                </div>

                {/* Rating & Stats */}
                <div className="flex items-center gap-4 mb-3">
                  <div className="flex items-center gap-1">
                    <Star className="text-yellow-500 fill-yellow-500" size={16} />
                    <span className="text-sm font-semibold text-foreground">{consultant.rating}</span>
                    <span className="text-xs text-muted-foreground">({consultant.reviews})</span>
                  </div>
                  <div className="flex items-center gap-1 text-muted-foreground">
                    <Award size={14} />
                    <span className="text-xs">{consultant.experience} 경력</span>
                  </div>
                </div>

                {/* Specialties */}
                <div className="flex flex-wrap gap-2 mb-3">
                  {consultant.specialties.map((specialty, idx) => (
                    <span
                      key={idx}
                      className="text-xs px-2.5 py-1 bg-primary/10 text-primary rounded-full"
                    >
                      #{specialty}
                    </span>
                  ))}
                </div>

                {/* Action Buttons */}
                <div className="flex gap-2">
                  <button className="flex-1 py-2.5 bg-card border border-border rounded-xl text-sm font-medium hover:bg-secondary transition-colors flex items-center justify-center gap-1.5">
                    <MessageCircle size={16} />
                    채팅 상담
                  </button>
                  <button className="flex-1 py-2.5 bg-primary text-primary-foreground rounded-xl text-sm font-medium hover:bg-primary/90 transition-colors flex items-center justify-center gap-1.5">
                    <Clock size={16} />
                    예약하기
                  </button>
                </div>
              </div>
            </div>

            {/* Recent Review */}
            <div className="bg-secondary rounded-xl p-3 border-t border-border">
              <div className="flex items-center gap-2 mb-1.5">
                <div className="flex">
                  {[1, 2, 3, 4, 5].map((star) => (
                    <Star key={star} className="text-yellow-500 fill-yellow-500" size={12} />
                  ))}
                </div>
                <span className="text-xs text-muted-foreground">최근 후기</span>
              </div>
              <p className="text-xs text-foreground leading-relaxed line-clamp-2">
                상담이 정말 도움이 되었습니다. 친절하고 자세한 설명 감사합니다!
              </p>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Empty State */}
      {filteredConsultants.length === 0 && (
        <div className="px-5 py-20 text-center">
          <div className="bg-secondary p-8 rounded-2xl mx-auto w-fit mb-4">
            <MessageCircle className="text-muted-foreground" size={48} />
          </div>
          <h3 className="font-semibold text-foreground mb-2">상담사가 없습니다</h3>
          <p className="text-sm text-muted-foreground">
            다른 카테고리를 선택해보세요
          </p>
        </div>
      )}
    </div>
  );
};
