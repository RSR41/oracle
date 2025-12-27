interface ErrorMessageProps {
  message: string;
  onRetry?: () => void;
}

export default function ErrorMessage({ message, onRetry }: ErrorMessageProps) {
  return (
    <div className="card border-2 border-red-200 bg-red-50">
      <div className="flex items-start space-x-3">
        <span className="text-2xl">?좑툘</span>
        <div className="flex-1">
          <h3 className="font-semibold text-red-900 mb-2">?ㅻ쪟媛 諛쒖깮?덉뒿?덈떎</h3>
          <p className="text-sm text-red-700 mb-4">{message}</p>
          {onRetry && (
            <button onClick={onRetry} className="btn-secondary text-sm">
              ?ㅼ떆 ?쒕룄
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
