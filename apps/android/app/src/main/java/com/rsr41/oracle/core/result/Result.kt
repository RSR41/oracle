package com.rsr41.oracle.core.result

/**
 * 네트워크/로컬 작업 결과를 감싸는 sealed class
 * 성공/에러/로딩 상태를 타입 안전하게 처리
 */
sealed class Result<out T> {
    data class Success<T>(val data: T) : Result<T>()
    data class Error(val exception: AppException) : Result<Nothing>()
    data object Loading : Result<Nothing>()
}

/**
 * 앱 전역 예외 클래스
 * 서버 에러 코드와 traceId를 포함
 */
sealed class AppException(
    val code: String,
    override val message: String,
    val traceId: String? = null
) : Exception(message) {
    class Network(traceId: String? = null) : AppException("NETWORK_ERROR", "네트워크 연결을 확인해주세요", traceId)
    class Server(code: String, message: String, traceId: String?) : AppException(code, message, traceId)
    class Unknown(traceId: String? = null) : AppException("UNKNOWN_ERROR", "알 수 없는 오류가 발생했습니다", traceId)
    class Validation(message: String) : AppException("VALIDATION_ERROR", message)
}

// Extension functions
inline fun <T, R> Result<T>.map(transform: (T) -> R): Result<R> = when (this) {
    is Result.Success -> Result.Success(transform(data))
    is Result.Error -> this
    is Result.Loading -> this
}

inline fun <T> Result<T>.onSuccess(action: (T) -> Unit): Result<T> {
    if (this is Result.Success) action(data)
    return this
}

inline fun <T> Result<T>.onError(action: (AppException) -> Unit): Result<T> {
    if (this is Result.Error) action(exception)
    return this
}

fun <T> Result<T>.getOrNull(): T? = when (this) {
    is Result.Success -> data
    else -> null
}
