---
name: 共通部品を優先して使う
description: 実装前に既存の共通ウィジェット（AppButton、AppBottomSheet等）を確認して積極的に使う
type: feedback
---

実装時は既存の共通部品が使えるところは最初から使う。後から「これ共通化しなかったっけ？」と指摘されないよう、実装前に core/widgets/ を確認する。

**Why:** ボトムシート実装時に AppBottomSheet、AppButton の存在を見落として生の Flutter ウィジェットで実装してしまい、後から置き換えることになった。

**How to apply:** UI 実装前に core/widgets/ を確認し、ボタンは AppButton、ボトムシートは AppBottomSheet 等の共通部品が使えないか検討する。
