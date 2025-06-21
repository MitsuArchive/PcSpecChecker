# PcSpecChecker

2025/06/21 初版  
Created by Studio Mitsu

## 【背景 / Background】

PCスペックを確認したいとき、コントロールパネルや設定画面をいちいち開くのは面倒です。  
本ツールは、Windowsマシンの基本的なハードウェア・システム構成を**PowerShellワンクリックで一覧表示**できるようにした、**シンプルかつ実用的なスペック確認スクリプト**です。

開発者やサポート対応時はもちろん、PCの状態記録や報告にも使えます。

## 【目的 / Purpose】

このツールは、以下の情報を**即時に一覧で表示**することを目的としています：

- OS情報（名称・バージョン・アーキテクチャ）
- CPU情報（型番・論理コア数）
- メモリ情報（総容量）
- GPU情報（名称・VRAM容量）
- ストレージ情報（SSD/HDDの種類と容量）
- 各ドライブの使用量と空き容量
- 仮想メモリ（ページファイル）の使用状況
- システム要約（PC名、物理メモリ、アーキテクチャなど）

## 【環境 / Environment】

- Windows 10 / 11
- PowerShell 5.1以降
- 管理者権限不要

## 【使い方 / Usage】

### 実行手順：

1. `PcSpecChecker.ps1` を右クリック  
2. 「PowerShellで実行」を選択  
3. スペック情報がコンソールに表示され、**キー入力後に終了**

> ログファイルは作成されません。必要な情報はコピー＆ペーストしてください。

```bash
PcSpecChecker/
├── PcSpecChecker.ps1         # 本体スクリプト（PowerShell）
├── README.md                 # 本ファイル
├── LICENSE                   # ライセンス
```

## 【ライセンス / License】
MIT License │ 自由に使用・改変・再配布可能

## 【著作権 / Copyright】
(c) 2025 Studio Mitsu

本ツールはPC情報確認を目的として提供されています。
システムの構成変更や自動収集目的での悪用は禁止されています。

💡 このツールが役立ったと感じたら、
[Buy Me a Coffee ☕](https://www.buymeacoffee.com/mitsuarchive) で応援していただけると嬉しいです！
