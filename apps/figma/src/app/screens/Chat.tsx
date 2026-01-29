import React, { useState } from 'react';
import { useApp } from '@/app/contexts/AppContext';
import { ArrowLeft, Send, MoreVertical, AlertCircle, Flag } from 'lucide-react';
import { motion } from 'motion/react';

interface ChatProps {
  onBack: () => void;
}

export const Chat: React.FC<ChatProps> = ({ onBack }) => {
  const { t } = useApp();
  const [message, setMessage] = useState('');
  const [showMenu, setShowMenu] = useState(false);
  const [showReport, setShowReport] = useState(false);

  // Mock chat data
  const chatUser = {
    name: '김서연',
    compatibility: 92,
  };

  const messages = [
    { id: 1, sender: 'other', text: '안녕하세요! 궁합이 잘 맞다고 해서 연락드려요 😊', time: '오후 2:30' },
    { id: 2, sender: 'me', text: '안녕하세요! 반갑습니다', time: '오후 2:32' },
    { id: 3, sender: 'other', text: '프로필 보니까 취미가 비슷하시네요', time: '오후 2:33' },
    { id: 4, sender: 'me', text: '네 맞아요! 저도 독서 좋아해요', time: '오후 2:35' },
  ];

  const handleSend = () => {
    if (message.trim()) {
      // Handle send logic
      setMessage('');
    }
  };

  const reportReasons = [
    '부적절한 언어 사용',
    '스팸 또는 광고',
    '사기 의심',
    '괴롭힘',
    '기타',
  ];

  if (showReport) {
    return (
      <div className="min-h-screen pb-20">
        {/* Header */}
        <div className="px-5 pt-6 pb-4 flex items-center gap-3">
          <button onClick={() => setShowReport(false)} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
            <ArrowLeft size={24} className="text-foreground" />
          </button>
          <div>
            <h1 className="text-2xl font-semibold text-foreground">신고하기</h1>
          </div>
        </div>

        {/* Warning */}
        <div className="px-5 mb-6">
          <div className="bg-destructive/10 border border-destructive/30 rounded-2xl p-5">
            <div className="flex items-start gap-3">
              <AlertCircle className="text-destructive flex-shrink-0" size={20} />
              <div className="flex-1">
                <h3 className="font-semibold text-foreground mb-2">신고 안내</h3>
                <ul className="text-sm text-muted-foreground space-y-1.5">
                  <li>• 허위 신고는 제재 대상이 될 수 있습니다</li>
                  <li>• 신고 내용은 관리자가 검토합니다</li>
                  <li>• 증거 자료가 있다면 함께 제출해주세요</li>
                </ul>
              </div>
            </div>
          </div>
        </div>

        {/* Report Reasons */}
        <div className="px-5 mb-6">
          <h3 className="font-semibold text-foreground mb-3">신고 사유</h3>
          <div className="space-y-2">
            {reportReasons.map((reason, idx) => (
              <button
                key={idx}
                className="w-full p-4 bg-card rounded-2xl border border-border hover:border-primary hover:bg-primary/5 transition-all text-left"
              >
                <div className="font-medium text-foreground">{reason}</div>
              </button>
            ))}
          </div>
        </div>

        {/* Additional Info */}
        <div className="px-5 mb-6">
          <h3 className="font-semibold text-foreground mb-3">추가 설명 (선택)</h3>
          <textarea
            placeholder="상황을 자세히 설명해주세요..."
            className="w-full h-32 p-4 bg-card border border-border rounded-2xl resize-none focus:outline-none focus:ring-2 focus:ring-primary/20 text-foreground placeholder:text-muted-foreground"
          />
        </div>

        {/* Submit */}
        <div className="px-5">
          <button className="w-full bg-destructive text-destructive-foreground py-4 rounded-2xl font-semibold hover:bg-destructive/90 transition-colors">
            신고 제출
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen flex flex-col pb-0">
      {/* Header */}
      <div className="px-5 pt-6 pb-4 flex items-center justify-between border-b border-border bg-card">
        <div className="flex items-center gap-3">
          <button onClick={onBack} className="p-2 -ml-2 hover:bg-secondary rounded-xl transition-colors">
            <ArrowLeft size={24} className="text-foreground" />
          </button>
          <div>
            <h2 className="font-semibold text-foreground">{chatUser.name}</h2>
            <div className="text-xs text-muted-foreground">궁합 {chatUser.compatibility}점</div>
          </div>
        </div>
        <div className="relative">
          <button 
            onClick={() => setShowMenu(!showMenu)}
            className="p-2 hover:bg-secondary rounded-xl transition-colors"
          >
            <MoreVertical size={20} className="text-foreground" />
          </button>
          
          {showMenu && (
            <motion.div
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              className="absolute right-0 top-full mt-2 bg-card border border-border rounded-2xl shadow-lg overflow-hidden z-10 min-w-[160px]"
            >
              <button 
                onClick={() => {
                  setShowMenu(false);
                  setShowReport(true);
                }}
                className="w-full px-4 py-3 text-left hover:bg-secondary transition-colors flex items-center gap-2"
              >
                <Flag size={16} className="text-destructive" />
                <span className="text-sm text-destructive font-medium">신고</span>
              </button>
              <button className="w-full px-4 py-3 text-left hover:bg-secondary transition-colors border-t border-border">
                <span className="text-sm text-foreground font-medium">차단</span>
              </button>
            </motion.div>
          )}
        </div>
      </div>

      {/* Messages */}
      <div className="flex-1 px-5 py-6 overflow-y-auto space-y-4">
        {messages.map((msg) => (
          <div
            key={msg.id}
            className={`flex ${msg.sender === 'me' ? 'justify-end' : 'justify-start'}`}
          >
            <div className={`max-w-[75%] ${msg.sender === 'me' ? 'items-end' : 'items-start'} flex flex-col`}>
              <div
                className={`px-4 py-3 rounded-2xl ${
                  msg.sender === 'me'
                    ? 'bg-primary text-primary-foreground'
                    : 'bg-card border border-border text-foreground'
                }`}
              >
                <p className="text-sm">{msg.text}</p>
              </div>
              <span className="text-xs text-muted-foreground mt-1 px-1">{msg.time}</span>
            </div>
          </div>
        ))}
      </div>

      {/* Safety Notice */}
      <div className="px-5 py-3 bg-primary/5 border-t border-primary/20">
        <div className="flex items-center gap-2">
          <AlertCircle className="text-primary flex-shrink-0" size={16} />
          <p className="text-xs text-muted-foreground">
            불편한 대화가 있다면 즉시 신고 또는 차단해주세요
          </p>
        </div>
      </div>

      {/* Input */}
      <div className="px-5 py-4 border-t border-border bg-card">
        <div className="flex items-center gap-3">
          <input
            type="text"
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            onKeyPress={(e) => e.key === 'Enter' && handleSend()}
            placeholder="메시지를 입력하세요..."
            className="flex-1 px-4 py-3 bg-secondary rounded-full focus:outline-none focus:ring-2 focus:ring-primary/20 text-foreground placeholder:text-muted-foreground"
          />
          <button
            onClick={handleSend}
            disabled={!message.trim()}
            className="w-12 h-12 bg-primary text-primary-foreground rounded-full flex items-center justify-center hover:bg-primary/90 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex-shrink-0"
          >
            <Send size={20} />
          </button>
        </div>
      </div>
    </div>
  );
};
