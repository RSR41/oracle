package com.rsr41.oracle.ui.screens.face

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import com.rsr41.oracle.R

/**
 * 관상 화면 - 얼굴 사진 업로드 및 분석
 */
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FaceReadingScreen(
    viewModel: FaceViewModel,
    onBack: () -> Unit
) {
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(stringResource(R.string.home_menu_face)) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, stringResource(R.string.common_back))
                    }
                }
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(20.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            if (viewModel.isAnalyzed) {
                // 분석 결과 카드
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.primaryContainer)
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Text(stringResource(R.string.common_result), style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
                        Spacer(modifier = Modifier.height(12.dp))
                        Text(viewModel.analysisResult)
                        Spacer(modifier = Modifier.height(16.dp))
                        OutlinedButton(onClick = { viewModel.reset() }, modifier = Modifier.align(Alignment.End) ) {
                            Text(stringResource(R.string.face_retake))
                        }
                    }
                }
            }

            // 개인정보 보호 안내
            Card(
                modifier = Modifier.fillMaxWidth(),
                colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.secondaryContainer)
            ) {
                Row(modifier = Modifier.padding(16.dp), verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Default.PrivacyTip, null, tint = MaterialTheme.colorScheme.secondary)
                    Spacer(modifier = Modifier.width(12.dp))
                    Column {
                        Text(stringResource(R.string.face_privacy_title), fontWeight = FontWeight.Bold)
                        Text(
                            stringResource(R.string.face_privacy_desc),
                            style = MaterialTheme.typography.bodySmall
                        )
                    }
                }
            }

            // 사진 업로드 영역
            Card(
                modifier = Modifier.fillMaxWidth().height(260.dp),
                colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)
            ) {
                if (viewModel.isAnalyzing) {
                    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                        Column(horizontalAlignment = Alignment.CenterHorizontally) {
                            CircularProgressIndicator()
                            Spacer(modifier = Modifier.height(16.dp))
                            Text(stringResource(R.string.face_analyzing))
                        }
                    }
                } else {
                    Column(
                        modifier = Modifier.fillMaxSize(),
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.Center
                    ) {
                        if (viewModel.isImageSelected) {
                            Icon(Icons.Default.Face, null, modifier = Modifier.size(64.dp), tint = MaterialTheme.colorScheme.primary)
                            Spacer(modifier = Modifier.height(8.dp))
                            Text(stringResource(R.string.face_ready), style = MaterialTheme.typography.titleMedium)
                        } else {
                            Text(stringResource(R.string.face_upload_hint), style = MaterialTheme.typography.titleMedium)
                        }
                        
                        Spacer(modifier = Modifier.height(24.dp))
                        Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                            Button(onClick = { viewModel.selectImage() }) {
                                Icon(Icons.Default.CameraAlt, null)
                                Spacer(modifier = Modifier.width(8.dp))
                                Text(stringResource(R.string.face_camera))
                            }
                            Button(onClick = { viewModel.selectImage() }) {
                                Icon(Icons.Default.PhotoLibrary, null)
                                Spacer(modifier = Modifier.width(8.dp))
                                Text(stringResource(R.string.face_gallery))
                            }
                        }
                    }
                }
            }

            // 안내사항
            Card(modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(stringResource(R.string.face_guide_title), style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                    Spacer(modifier = Modifier.height(12.dp))
                    Text(stringResource(R.string.face_guide_1))
                    Text(stringResource(R.string.face_guide_2))
                    Text(stringResource(R.string.face_guide_3))
                    Text(stringResource(R.string.face_guide_4))
                }
            }

            Button(
                onClick = { viewModel.analyze() },
                modifier = Modifier.fillMaxWidth().height(56.dp),
                enabled = viewModel.isImageSelected && !viewModel.isAnalyzing && !viewModel.isAnalyzed
            ) {
                Text(stringResource(R.string.face_analyze_btn))
            }
        }
    }
}
