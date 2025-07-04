<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8" />
<title>${subject}の結果|K-Manage</title>
<link rel="stylesheet" href="<c:url value='/css/K-style.css' />">
<link rel="stylesheet" href="<c:url value='/css/SubjectResult.css' />">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
</head>

<body>
	<div class="wrapper">
		<!-- ヘッダー -->
		<h1 id="logo">
			<a href="<c:url value='/HomeServlet' />"> <img
				src="<c:url value='/img/K-Manage_logo.png' />" alt="K-Manage">
			</a>
		</h1>

		<ul id="nav">
			<li><a href="<c:url value='/HomeServlet' />">ホーム</a></li>
			<li><a href="<c:url value='/StudentListServlet' />">生徒一覧</a></li>
			<li><a href="<c:url value='/RegistServlet' />">登録</a></li>
			<li><a href="<c:url value='/SearchServlet' />">検索</a></li>
			<li><a href="<c:url value='/LogoutServlet' />"
				onclick="return confirm('本当に実行しますか？');">ログアウト</a></li>
		</ul>

		<h2>${subject}の結果</h2>

		<a
			href="<c:url value='/IndividualResultsServlet?studentId=${student.id}' />"
			class="diag-link-button">個人結果に戻る</a>

		<!-- 教科ナビゲーション -->
		<ul class="subject-nav">
			<li><a
				href="<c:url value='/SubjectResultServlet?studentId=${student.id}&subjectId=1' />">国語</a></li>
			<li><a
				href="<c:url value='/SubjectResultServlet?studentId=${student.id}&subjectId=2' />">数学</a></li>
			<li><a
				href="<c:url value='/SubjectResultServlet?studentId=${student.id}&subjectId=4' />">理科</a></li>
			<li><a
				href="<c:url value='/SubjectResultServlet?studentId=${student.id}&subjectId=5' />">社会</a></li>
			<li><a
				href="<c:url value='/SubjectResultServlet?studentId=${student.id}&subjectId=3' />">英語</a></li>
			<li><a
				href="<c:url value='/SubjectResultServlet?studentId=${student.id}&subjectId=10' />">総合</a></li>
		</ul>

		<!-- メッセージ表示 -->
		<c:if test="${not empty message}">
			<div class="message"
				style="background: lightgreen; padding: 10px; margin: 10px; border-radius: 5px;">
				${message}</div>
		</c:if>

		<form method="post" action="<c:url value='/SubjectResultServlet' />">
			<input type="hidden" name="action" value="update" /> <input
				type="hidden" name="studentId" value="${studentId}" /> <input
				type="hidden" name="subjectId" value="${subjectId}" />

			<!-- 基本情報 -->
			<section class="centered basic-info-section">
				<h3>基本情報</h3>
				<div class="flex-row" style="justify-content: center;">
					<div class="field">
						<label for="name">氏名</label> <span>${student.name}</span>
					</div>
					<div class="field">
						<label for="kana">ふりがな</label> <span>${student.furigana}</span>
					</div>
				</div>
			</section>

			<!-- 総合以外の場合のみ表示 -->
			<c:if test="${subjectId != 10}">
				<!-- 学習計画 -->
				<section class="centered">
					<h3>学習計画</h3>
					<!-- 理解度（真ん中） -->
					<div class="flex-row" style="justify-content: center;">
						<div class="field">
							<label for="understanding">理解度</label> <input type="number"
								id="understanding" name="understanding"
								value="${subjectData.understanding}" min="1" max="10" step="1" />
							<button type="button" onclick="updateUnderstanding()"
								class="understanding-update-btn">更新</button>
						</div>
					</div>
					<!-- テキスト選出・スケジュール作成・宿題ページ数 -->
					<div class="flex-row" style="justify-content: center;">
						<div class="field">
							<label for="text_selection">テキスト選出</label>
							<c:choose>
								<c:when
									test="${not empty subjectData.textSelection and subjectData.textSelection != 'null' and subjectData.textSelection != ''}">
									<span>${subjectData.textSelection}</span>
								</c:when>
								<c:otherwise>
									<span style="color: #999; font-style: italic;">未選出</span>
								</c:otherwise>
							</c:choose>
							<c:url var="textUrl" value="/TextServlet">
								<c:param name="studentId" value="${studentId}" />
								<c:param name="subjectId" value="${subjectId}" />
							</c:url>
							<a href="${textUrl}" class="diag-link-button">テキスト選出はこちら</a>
						</div>
						<div class="field">
							<label for="schedule">スケジュール作成(テキスト選出を先に)</label>
							<c:choose>
								<c:when test="${not empty subjectData.schedule}">
									<span>${subjectData.schedule}</span>
								</c:when>
								<c:otherwise>
									<span style="color: #999; font-style: italic;">未作成</span>
								</c:otherwise>
							</c:choose>
							<c:url var="scheduleUrl" value="/ScheduleServlet">
								<c:param name="studentId" value="${studentId}" />
								<c:param name="subjectId" value="${subjectId}" />
							</c:url>
							<!-- テキスト選出の有無で条件分岐 -->
							<c:choose>
								<c:when
									test="${not empty subjectData.textSelection and subjectData.textSelection != 'null' and subjectData.textSelection != '未選出'}">
									<!-- テキスト選出済み：通常のボタン -->
									<a href="${scheduleUrl}" class="diag-link-button">スケジュール作成はこちら</a>
								</c:when>
								<c:otherwise>
									<!-- テキスト未選出：無効化ボタン -->
									<span class="diag-link-button-disabled" title="先にテキストを選出してください">スケジュール作成はこちら</span>
								</c:otherwise>
							</c:choose>
						</div>
						<div class="field">
							<label for="homework_pages">宿題ページ数</label>
							<c:choose>
								<c:when test="${not empty subjectData.homeworkPages}">
									<span>${subjectData.homeworkPages}</span>
								</c:when>
								<c:otherwise>
									<span style="color: #999; font-style: italic;">未設定</span>
								</c:otherwise>
							</c:choose>
							<c:url var="homeworkUrl" value="/HomeworkServlet">
								<c:param name="studentId" value="${studentId}" />
								<c:param name="subjectId" value="${subjectId}" />
							</c:url>
							<a href="${homeworkUrl}" class="diag-link-button">宿題提案はこちら</a>
						</div>
					</div>
				</section>

				<!-- メモ欄 -->
				<section class="centered">
					<h3>前回やったこと</h3>
					<textarea name="lastContent" class="large-textbox">${subjectData.lastContent}</textarea>
				</section>
				<section class="centered">
					<h3>次回やること</h3>
					<textarea name="nextContent" class="large-textbox">${subjectData.nextContent}</textarea>
				</section>
				<section class="centered">
					<h3>宿題内容</h3>
					<textarea name="homework" class="large-textbox">${subjectData.homework}</textarea>
				</section>
				<section class="centered">
					<h3>備考</h3>
					<textarea name="note" class="large-textbox">${subjectData.note}</textarea>
				</section>

				<!-- 保存ボタン -->
				<div class="section-btn-row">
					<button type="submit" class="save-btn">更新</button>
				</div>
			</c:if>
		</form>

		<!-- 模試結果 -->
		<section class="centered">
			<h3>${subject}の模試結果推移</h3>
			<!-- 模試名選択 -->
			<div class="exam-selector">
				<label for="examNameSelect">模試名を選択:</label> <select
					id="examNameSelect" onchange="updateChart()">
					<option value="">すべての模試</option>
				</select>
			</div>

			<!-- グラフコンテナ -->
			<div class="chart-container">
				<canvas id="examChart"></canvas>
			</div>
		</section>

		<section class="centered">
			<h3>${subject}の模試結果一覧</h3>
			<table>
				<thead>
					<tr>
						<th>模試名</th>
						<th>実施日</th>
						<th>点数</th>
						<th>偏差値</th>
						<th>平均</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="exam" items="${subjectData.examResults}">
						<tr>
							<td><input type="text" value="${exam.examName}"
								id="examName_${exam.id}" /></td>
							<td><input type="date"
								value="<fmt:formatDate value='${exam.examDate}' pattern='yyyy-MM-dd' />"
								id="examDate_${exam.id}" /></td>
							<td><input type="number" value="${exam.score}"
								id="score_${exam.id}" min="0" max="100" /></td>
							<td><input type="number" value="${exam.deviationValue}"
								id="dev_${exam.id}" step="0.1" /></td>
							<td><input type="number" value="${exam.averageScore}"
								id="avg_${exam.id}" step="0.1" /></td>
							<td>
								<button type="button" onclick="updateExam(${exam.id})"
									class="table-edit-btn">更新</button>
								<button type="button" onclick="deleteExam(${exam.id})"
									class="delete-btn">削除</button>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</section>

		<a
			href="<c:url value='/IndividualResultsServlet?studentId=${student.id}' />"
			class="diag-link-button">個人結果に戻る</a>
	</div>

	<!-- データを JavaScript に渡すための hidden elements -->
	<div id="contextData" data-student-id="${studentId}"
		data-subject-id="${subjectId}"
		data-servlet-url="<c:url value='/SubjectResultServlet' />"
		style="display: none;"></div>

	<script src="<c:url value='/js/SubjectResult.js' />"></script>

	<!-- JSPファイルの<script>タグ内を以下に置き換える -->
	<script>
    // 模試データをJavaScriptに渡す
    var examData = [];
    <c:forEach var="exam" items="${subjectData.examResults}">
        examData.push({
            examName: "${fn:escapeXml(exam.examName)}",
            examDate: "<fmt:formatDate value='${exam.examDate}' pattern='yyyy-MM-dd' />",
            score: ${exam.score},
            deviationValue: ${exam.deviationValue},
            averageScore: ${exam.averageScore}
        });
    </c:forEach>

    // 現在の教科名
    var currentSubject = "${fn:escapeXml(subject)}";

    // デバッグ情報の出力
    //console.log('Exam data:', examData);
    //console.log('Current subject:', currentSubject);
    //console.log('Chart.js available:', typeof Chart !== 'undefined');

    // チャート初期化関数の安全な呼び出し
    function safeInitializeChart() {
        //console.log('Attempting to initialize chart...');
        
        // Chart.jsの確認
        if (typeof Chart === 'undefined') {
            //console.error('Chart.js is not loaded');
            return;
        }
        
        // 必要な要素の確認
        const chartCanvas = document.getElementById('examChart');
        const selectElement = document.getElementById('examNameSelect');
        
        if (!chartCanvas) {
            //console.error('Chart canvas element not found');
            return;
        }
        
        if (!selectElement) {
            //console.error('Select element not found');
            return;
        }
        
        // チャート初期化関数の確認と実行
        if (typeof initializeExamChart === 'function') {
            const success = initializeExamChart(examData, currentSubject);
            if (success) {
                //console.log('Chart initialization successful');
            } else {
                //console.error('Chart initialization failed');
            }
        } else {
            //console.error('initializeExamChart function not found');
            // 少し待ってから再試行
            setTimeout(function() {
                if (typeof initializeExamChart === 'function') {
                    const success = initializeExamChart(examData, currentSubject);
                    if (success) {
                        //console.log('Chart initialization successful (retry)');
                    } else {
                        //console.error('Chart initialization failed (retry)');
                    }
                } else {
                    //console.error('initializeExamChart function still not found after retry');
                }
            }, 500);
        }
    }

    // 複数のタイミングで初期化を試行
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', safeInitializeChart);
    } else {
        // DOMが既に読み込まれている場合は即座に実行
        safeInitializeChart();
    }
    
    // 追加の安全策として、window.onloadでも試行
    window.addEventListener('load', function() {
        // チャートが初期化されていない場合のみ実行
        if (!window.examChartInstance || !window.examChartInstance.chart) {
            //console.log('Retrying chart initialization on window load...');
            safeInitializeChart();
        }
    });
</script>
</body>
</html>