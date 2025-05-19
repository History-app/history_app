import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";

// Firebase Admin SDK を初期化
admin.initializeApp();

export const addMissingCards = functions.https.onRequest(async (req, res) => {
  const db = admin.firestore();

  try {
    const usersSnap = await db.collection("users").get();

    for (const userDoc of usersSnap.docs) {
      const userId = userDoc.id;
      const cardsRef = db
        .collection("users")
        .doc(userId)
        .collection("learnedCards");

      // 既存IDを取得して重複を防止
      const existingSnap = await cardsRef.get();
      const existingIds = new Set(existingSnap.docs.map((d) => d.id));

      const batch = db.batch();
      for (let i = 53; i <= 136; i++) {
        const padded =
          i <= 52
            ? i.toString().padStart(2, "0")
            : i.toString().padStart(3, "0");
        const cardId = `Card${padded}`;
        if (existingIds.has(cardId)) continue;

        const ref = cardsRef.doc(cardId);
        batch.set(ref, {
          noteRef: `note${padded}`,
          left: null,
          lapses: 0,
          ivl: 1,
          type: 0,
          queue: 0,
          reps: 0,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          due: null,
          factor: 2500,
        });
      }
      await batch.commit();
      console.log(`✔ ユーザー ${userId} に Card053〜Card136 を追加`);
    }

    res.status(200).send("All users updated.");
  } catch (err) {
    console.error(err);
    res.status(500).send("Error adding missing cards.");
  }
});

// ユーザー作成時にトリガーされる関数
export const createAnonymousUserDoc = functions.auth
  .user()
  .onCreate(async (user: admin.auth.UserRecord) => {
    // providerData が空の場合、匿名ユーザーと判断
    if (user.providerData.length === 0) {
      const userData = {
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        isAnonymous: true,
      };

      try {
        // 1. まずユーザードキュメントを作成
        await admin.firestore().collection("users").doc(user.uid).set(userData);

        // 2. 初期カードのデータを準備
        // 2. 初期カードのデータを準備
        const initialCards = [];

        for (let i = 1; i <= 136; i++) {
          // 1〜52は2桁パディング、53以降は3桁パディング
          const paddedNumber =
            i <= 52
              ? i.toString().padStart(2, "0")
              : i.toString().padStart(3, "0");

          initialCards.push({
            id: `Card${paddedNumber}`,
            noteRef: `note${paddedNumber}`,
            left: null,
            lapses: 0,
            ivl: 1,
            type: 0,
            queue: 0,
            reps: 0,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            due: null,
            factor: 2500,
          });
        }

        // 3. バッチ処理でカードをまとめて作成
        // バッチ処理でカードをまとめて作成
        const batch = admin.firestore().batch();
        initialCards.forEach((card) => {
          const cardRef = admin
            .firestore()
            .collection("users")
            .doc(user.uid)
            .collection("learnedCards")
            .doc(card.id);

          // idを除外した新しいオブジェクトを作成
          const { id, ...cardWithoutId } = card;

          batch.set(cardRef, {
            ...cardWithoutId,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        });

        // バッチ実行
        await batch.commit();

        console.log(
          `Anonymous user document and ${initialCards.length} initial cards created for: ${user.uid}`
        );
      } catch (error) {
        console.error(`Error creating documents for ${user.uid}:`, error);
      }
    }
  });

// 管理用：日本の歴史に関するサンプルノートをchapter2に追加する関数
export const seedSampleNotesToChapter2 = functions.https.onRequest(
  async (req, res) => {
    try {
      // 日本史のサンプルノートデータ
      const sampleNotes = [
        {
          id: "note01",
          sfld: "人類の進化の過程は4段階に分けられるが、1番目の段階は何か",

          flds: [
            "人類の進化の過程は4段階に分けられるが、1番目の段階は何か",
            "猿人",
          ],
        },
        {
          id: "note02",
          sfld: "人類の進化の過程は4段階に分けられるが、2番目の段階は何か",
          flds: [
            "人類の進化の過程は4段階に分けられるが、2番目の段階は何か",

            "原人",
          ],
        },
        {
          id: "note03",
          sfld: "人類の進化の過程は4段階に分けられるが、3番目の段階は何か",
          flds: [
            "人類の進化の過程は4段階に分けられるが、3番目の段階は何か",
            "旧人",
          ],
        },
        {
          id: "note04",
          sfld: "人類の進化の過程は4段階に分けられるが、4番目の段階は何か",
          flds: [
            "人類の進化の過程は4段階に分けられるが、4番目の段階は何か",
            "新人",
          ],
        },
        {
          id: "note05",
          sfld: "日本列島で人類が生活をし始めた、１万年前までの期間の地質学名称は？",
          flds: [
            "日本列島で人類が生活をし始めた、１万年前までの期間の地質学名称は？",
            "更新世",
          ],
        },
        {
          id: "note06",
          sfld: "更新世の別称は？",
          flds: ["更新世の別称は？", "氷河時代"],
        },
        {
          id: "note07",
          sfld: "更新世（氷河時代）のうち、寒冷な期間の名称は？",
          flds: ["更新世（氷河時代）のうち、寒冷な期間の名称は？", "氷期"],
        },
        {
          id: "note08",
          sfld: "更新世（氷河時代）のうち、温暖な期間の名称は？",
          flds: ["更新世（氷河時代）のうち、温暖な期間の名称は？", "間氷期"],
        },
        {
          id: "note09",
          sfld: "1万年前以降の時代の地質学名称は?",
          flds: ["1万年前以降の時代の地質学名称は？", "完新世"],
        },
      ];

      console.log(`データの追加を開始: ${sampleNotes.length}件のノート`);

      // バッチ処理の準備
      const batch = admin.firestore().batch();

      // 各ノートをFirestoreに追加
      sampleNotes.forEach((note) => {
        // ドキュメント参照の作成
        const noteRef = admin
          .firestore()
          .collection("books")
          .doc("book1")
          .collection("chapters")
          .doc("chapter1")
          .collection("notes")
          .doc(note.id);

        // idを除外した新しいオブジェクトを作成
        const { id, ...noteWithoutId } = note;

        // バッチにセット操作を追加
        batch.set(noteRef, {
          ...noteWithoutId, // idを除いたノートデータ
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      });

      // バッチ処理を実行
      await batch.commit();
      console.log("データ追加完了");

      // 成功レスポンスを返す
      res.status(200).json({
        success: true,
        message: `${sampleNotes.length}件のサンプルノートがchapter2に追加されました`,
      });
    } catch (error) {
      // エラーログとレスポンス
      console.error("サンプルノート追加中にエラーが発生:", error);
      res.status(500).json({
        success: false,
        message: "サンプルノートの追加に失敗しました",
        error: error instanceof Error ? error.toString() : String(error),
      });
    }
  }
);

// ユーザーに初期カードを追加するHTTP関数（シンプル版）
export const addUserCards = functions.https.onRequest(async (req, res) => {
  try {
    // リクエストからユーザーIDを取得
    const { userId } = req.body;

    if (!userId) {
      res.status(400).json({ error: "ユーザーIDが必要です" });
    }

    // 初期カードのデータ
    const initialCards = Array.from({ length: 24 }, (_, index) => {
      const num = index + 23;
      return {
        id: `Card${num}`,
        noteRef: `note${num}`,
        left: null,
        lapses: 0,
        ivl: 1,
        type: 0,
        queue: 0,
        reps: 0,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        due: null,
        factor: 2500,
      };
    });

    // バッチ処理でカードを追加
    const batch = admin.firestore().batch();

    initialCards.forEach((card) => {
      const cardRef = admin
        .firestore()
        .collection("users")
        .doc(userId)
        .collection("learnedCards")
        .doc(card.id);

      const { id, ...cardWithoutId } = card;
      batch.set(cardRef, cardWithoutId);
    });

    await batch.commit();

    res.status(200).json({ success: true });
  } catch (error) {
    res.status(500).json({ success: false, error: String(error) });
  }
});

export const seedNotesToChapter3 = functions.https.onRequest(
  async (req, res) => {
    try {
      // 問題文と解答の配列
      const questions = [
        "水稲耕作が日本で定着してから古墳が作られるまでの時代区分は？",
        "弥生時代を4つに区分すると？",
        "弥生文化が及ばなかった北海道において広がった文化は？",
        "弥生文化が及ばなかった南西諸島において広がった文化は？",
        "弥生土器の由来となった、土器が発見された東京都の本郷弥生町にあった貝塚は？",
        "稲の穂を摘むために用いられた道具は？",
        "弥生時代前期〜中期にかけて伝来した青銅器や鉄器をまとめてなんという？",
        "金属器のうち、銅と錫の合金でできたものは？",
        "収穫した稲を保存するための倉庫の名称は？",
        "収穫した作物を保管するための穴の名称は？",
        "脱穀に用いた道具は？",
        "低湿地に設けられた初期の水田の名称は？",
        "自然堤防や段丘に設けられ、灌漑を行うやや湿った水田の名称は？",
        "排水が良好で灌漑が必要な生産性の高い水田の名称は？",
        "弥生時代前期に行われた種まきの方法は？",
        "弥生時代後期に行われた種まきの方法は？",
        "弥生時代において家畜として飼育されていたことが確認されている動物を二つ挙げよ",
        "水田の耕作に用いられた木製の農具を二つ挙げよ",
        "水田で足が沈むのを防ぐために用いられた農具は？",
        "水田に堆肥や青草を踏み込むために用いられた農具は？",
        "収穫した稲を水田上で運ぶために用いられた道具は？",
        "石包丁を用いて行われた稲の収穫方法の名称は？",
        "弥生時代後期から始まった、鉄鎌を用いて行われた稲の収穫方法の名称は？",
        "住居や水田跡で知られる静岡県静岡市の遺跡は？",
        "水田跡で有名な青森県の遺跡を二つ挙げよ",
        "水田跡で有名な静岡県伊豆の国市に位置する遺跡は？",
        "弥生土器のうち、煮炊きに用いられたのは？",
        "弥生土器のうち、穀物の貯蔵に用いられたのは？",
        "弥生土器のうち、食べ物の盛り付けに用いられたのは？",
        "弥生土器のうち、食べ物を蒸すために用いられたのは？",
        "弥生時代の死者の埋葬方法の名称は？",
        "主に九州北部に見られる、地上に大きな石を配置した墓の名称は？",
        "死者を入れた大型の土器の名称は？",
        "板を組み合わせた棺に埋葬した弥生時代の墓の名称は？",
        "北九州に多くみられる、板石を組み合わせて作った棺による墓の名称は？",
        "方形の墳丘の周りに溝を巡らせた墓の名称は？",
        "東日本で行われていた、一度埋葬して白骨化した遺体を土器などに詰めて再度埋葬した墓の名称は？",
        "吉備地方（岡山県）で見られる、墳丘の周囲に突出部を持つ墓の名称は？",
        "山陰地方で見られる、墳丘の周囲に突出部を持つ墓の名称は？",
        "墓に遺体と共に埋葬された様々な物の総称は？",
        "九州北部に多く見られる青銅器を二つ挙げよ",
        "瀬戸内海地域に多く見られる青銅器は？",
        "近畿地方に多く見られる青銅器は？",
        "銅剣・銅矛・銅戈がまとまって出土した島根県出雲市斐川町の遺跡は？",
        "銅鐸が出土したことで知られる島根県の遺跡は？",
        "弥生時代になって出現し始めた、周囲に溝をめぐらせた集落の名称は？",
        "佐賀県に位置する巨大な環濠集落の遺跡は？",
        "環濠集落の代表例である、奈良県の遺跡の名称は？",
        "弥生時代になって出現し始めた、平地よりも高い場所につくられた集落の名称は？",
        "高地性集落の代表例である香川県の遺跡は？",
        "高地性集落の代表例である、大阪府の遺跡は？",
        "神奈川県横浜市に位置する環濠集落の遺跡は？",
        "大阪府和泉市に位置する環濠集落の遺跡は？",
        "弥生時代に出現し始めた、いくつかの集落からなる政治的なまとまりの名称は？",
        "1世紀ごろに編纂され、当時の日本の状況についても記載されている中国の歴史書は？",
        "漢書の著者は？",
        "『漢書』地理志では日本列島の人々と国はなんと記されている？",
        "『漢書』地理志で倭国が朝貢に訪れていたと記されている、朝鮮の地域は？",
        "紀元57年に倭の奴国の王の使者が中国を訪れたとの記載がある中国の歴史書は？",
        "奴国の王の使者が訪れた、後漢の都は？",
        "奴国の王に金印を与えた後漢の皇帝は？",
        "奴国の王が後漢の光武帝から与えられた金印に彫られている文言は？",
        "107年に後漢の安帝に生口160人を献じたのは誰？",
        "倭国王帥升が後漢の安帝に献じたのは？",
        "倭国王帥升が生口160人を献じたのは？",
        "邪馬台国の記載がある中国の歴史書は？",
        "「魏志」倭人伝の正式名称は？",
        "「魏志」倭人伝の著者は？",
        "三国志の三国の国名を挙げよ",
        "239年に魏に使者を派遣した邪馬台国の女王は？",
        "卑弥呼が女王を務めた国（政治連合）の名称は？",
        "卑弥呼が魏から与えられた称号は？",
        "卑弥呼が使者を派遣した朝鮮半島の地域は？",
        "『魏志』倭人伝において、卑弥呼の呪術はなんと記されている？",
        "邪馬台国と対立して争った国は？",
        "卑弥呼の死後、争いを収めるために女王となった卑弥呼の宗女の名は？",
        "壱与（台与）が使者を送った中国の王朝名とその都は？",
        "邪馬台国が伊都国に設置していた役所の名称は？",
        "邪馬台国にはなんという身分が存在していた？二つ挙げよ",
        "邪馬台国論争において、邪馬台国が位置するとされている地域は？",
        "邪馬台国が近畿に位置した場合、どんなことが言える？",
        "邪馬台国が九州北部に位置した場合、どんなことが言える？",
        "邪馬台国が近畿にあった根拠とされる遺跡は？",
        "卑弥呼の墓だという説のある古墳は？",
      ];

      const answers = [
        "弥生時代",
        "早期、前期、中期、後期",
        "続縄文文化",
        "貝塚文化",
        "向ヶ丘貝塚",
        "石包丁",
        "金属器",
        "青銅器",
        "高床倉庫",
        "貯蔵穴",
        "木臼と竪杵",
        "湿田",
        "半乾田",
        "乾田",
        "直播",
        "田植え",
        "ブタとイノシシ",
        "木鍬と木鍬",
        "田下駄",
        "大足",
        "田舟",
        "穂首刈り",
        "根刈り",
        "登呂遺跡",
        "垂柳遺跡と砂沢遺跡",
        "山木遺跡",
        "甕",
        "壺",
        "高杯",
        "甑",
        "伸展葬",
        "支石墓",
        "甕棺墓",
        "木棺墓",
        "箱式石棺墓",
        "方形周溝墓",
        "再葬墓",
        "楯築墳丘墓",
        "四隅突出型墳丘墓",
        "副葬品",
        "銅矛と銅戈",
        "平形銅剣",
        "銅鐸",
        "荒神谷遺跡",
        "加茂岩倉遺跡",
        "環濠集落",
        "吉野ヶ里遺跡",
        "唐古・鍵遺跡",
        "高地性集落",
        "紫雲出山遺跡",
        "古曽部・芝谷遺跡",
        "大塚遺跡",
        "池上曽根遺跡",
        "クニ",
        "『漢書』地理志",
        "班固",
        "倭人、倭国",
        "楽浪郡",
        "『後漢書』東夷伝",
        "洛陽",
        "光武帝",
        "漢委奴国王",
        "倭国王帥升",
        "生口160人",
        "安帝",
        "『三国志』の「魏志」倭人伝",
        "「魏書」東夷伝倭人の条",
        "陳寿",
        "魏・呉・蜀",
        "卑弥呼",
        "邪馬台国",
        "親魏倭王",
        "帯方郡",
        "鬼道",
        "狗奴国",
        "壱与（台与）",
        "晋、洛陽",
        "一大率",
        "大人・下戸",
        "九州北部または近畿",
        "3世紀前半には近畿から九州北部に及ぶ政治連合が形成されており、邪馬台国はのちのヤマト政権につながる。",
        "邪馬台国は九州北部の小規模な政治連合であり、のちに近畿地方で成立するヤマト政権に統合されたか、邪馬台国の勢力が東に勢力を伸ばし、ヤマト政権になった。",
        "纏向遺跡",
        "箸墓古墳",
      ];

      // note53 から連番で ID を振る
      const difficulties = [
        "A",
        "C",
        "A",
        "A",
        "B",
        "B",
        "A",
        "A",
        "A",
        "B",
        "B",
        "B",
        "C",
        "B",
        "C",
        "C",
        "C",
        "B",
        "B",
        "B",
        "B",
        "C",
        "C",
        "A",
        "A",
        "B",
        "A",
        "A",
        "A",
        "A",
        "A",
        "A",
        "A",
        "B",
        "B",
        "A",
        "A",
        "A",
        "A",
        "A",
        "B",
        "B",
        "B",
        "A",
        "C",
        "A",
        "A",
        "A",
        "A",
        "A",
        "C",
        "C",
        "C",
        "A",
        "A",
        "C",
        "A",
        "A",
        "A",
        "C",
        "B",

        "A",
        "B",

        "C",
        "C",
        "A",
        "C",
        "C",
        "B",
        "A",
        "A",
        "A",
        "B",
        "C",
        "A",
        "A",
        "C",
        "C",
        "B",
        "A",
        "C",
        "C",
        "B",
        "B",
      ];

      // 難易度文字を数値にマップ
      const letterMap: Record<string, number> = { A: 3, B: 2, C: 1 };

      // note53 から連番で ID を振り、theme と star（難易度）を追加
      const sampleNotes = questions.map((sfld, i) => {
        // 数値を計算
        const noteNumber = 53 + i;
        // 3桁にゼロパディングしたID文字列を生成（例: note053）
        const paddedId = `note${noteNumber.toString().padStart(3, "0")}`;

        return {
          id: paddedId,
          sfld,
          flds: [sfld, answers[i]],
          theme: "弥生時代",
          star: letterMap[difficulties[i]],
        };
      });

      const batch = admin.firestore().batch();
      sampleNotes.forEach((note) => {
        const { id, ...data } = note;
        const noteRef = admin
          .firestore()
          .collection("books")
          .doc("book1")
          .collection("chapters")
          .doc("chapter3")
          .collection("notes")
          .doc(id);
        batch.set(noteRef, {
          ...data,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      });

      await batch.commit();

      res.status(200).json({
        success: true,
        message: `${sampleNotes.length} 件のノートが chapter3 に追加されました`,
      });
    } catch (error) {
      console.error("chapter3への追加エラー:", error);
      res.status(500).json({
        success: false,
        message: "chapter3 へのノート追加に失敗しました",
        error: error instanceof Error ? error.toString() : String(error),
      });
    }
  }
);
