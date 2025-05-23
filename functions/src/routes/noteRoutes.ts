import * as functions from "firebase-functions/v1";
import { seedNotes } from "../controllers/noteController";
import { createNoteData } from "../models/noteModel";

const chapter1Notes = [
  {
    id: "note01", // ← ドキュメントID
    flds: [
      "人類の進化の過程は4段階に分けられるが、1番目の段階は何か",
      "猿人",
      "えんじん",
    ], // ← 質問、答え、読み
    hnref: 10, // ← 任意のリンク番号（たぶん定数か生成）
    sfld: "人類の進化...", // ← 表示用の質問文（たぶん同じ内容）
    star: 3, // ← 重要度など？
    theme: "人類の進化", // ← 分類用テーマ
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note02",
    flds: [
      "人類の進化の過程は4段階に分けられるが、2番目の段階は何か",
      "原人",
      "げんじん",
    ],
    hnref: 10,
    sfld: "人類の進化の過程は4段階に分けられるが、2番目の段階は何か",
    star: 3,
    theme: "人類の進化",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note03",
    flds: [
      "人類の進化の過程は4段階に分けられるが、3番目の段階は何か",
      "旧人",
      "きゅうじん",
    ],
    hnref: 10,
    sfld: "人類の進化の過程は4段階に分けられるが、3番目の段階は何か",
    star: 3,
    theme: "人類の進化",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note04",
    flds: [
      "人類の進化の過程は4段階に分けられるが、4番目の段階は何か",
      "新人",
      "しんじん",
    ],
    hnref: 10,
    sfld: "人類の進化の過程は4段階に分けられるが、4番目の段階は何か",
    star: 3,
    theme: "人類の進化",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note05",
    flds: [
      "日本列島で人類が生活をし始めた、１万年前までの期間の地質学名称は？",
      "更新世",
      "こうしんせい",
    ],
    hnref: 1,
    sfld: "日本列島で人類が生活をし始めた、１万年前までの期間の地質学名称は？",
    star: 3,
    theme: "旧石器と縄文の環境",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note06",
    flds: ["更新世の別称は？", "氷河時代", "ひょうがじだい"],
    hnref: 1,
    sfld: "更新世の別称は？",
    star: 2,
    theme: "旧石器と縄文の環境",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note07",
    flds: [
      "更新世（氷河時代）のうち、寒冷な期間の名称は？",
      "氷期",
      "ひょうき",
    ],
    hnref: 1,
    sfld: "更新世（氷河時代）のうち、寒冷な期間の名称は？",
    star: 2,
    theme: "旧石器と縄文の環境",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note08",
    flds: [
      "更新世（氷河時代）のうち、温暖な期間の名称は？",
      "間氷期",
      "かんぴょうき",
    ],
    hnref: 1,
    sfld: "更新世（氷河時代）のうち、温暖な期間の名称は？",
    star: 2,
    theme: "旧石器と縄文の環境",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note09",
    flds: ["1万年前以降の時代の地質学名称は？", "完新世", "かんしんせい"],
    hnref: 1,
    sfld: "1万年前以降の時代の地質学名称は？",
    star: 3,
    theme: "旧石器と縄文の環境",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note10",
    flds: ["長野県野尻湖で化石が発見された大型動物は？", "ナウマンゾウ"],
    hnref: 8,
    sfld: "長野県野尻湖で化石が発見された大型動物は？",
    star: 3,
    theme: "旧石器時代の遺跡",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note11",
    flds: [
      "静岡県浜松市において発見された更新世の人骨の化石の名称は？",
      "浜北人",
      "はまきたじん",
    ],
    hnref: 8,
    sfld: "静岡県浜松市において発見された更新世の人骨の化石の名称は？",
    star: 2,
    theme: "旧石器時代の遺跡",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note12",
    flds: [
      "沖縄県八重瀬町で発見された更新世の人骨の化石の名称は？",
      "港川人",
      "みなとがわじん",
    ],
    hnref: 8,
    sfld: "沖縄県八重瀬町で発見された更新世の人骨の化石の名称は？",
    star: 2,
    theme: "旧石器時代の遺跡",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note13",
    flds: [
      "沖縄県那覇市で発見された更新世の人骨の化石の名称は？",
      "山下町第一洞人",
      "やましたちょうだいいちどうじん",
    ],
    hnref: 8,
    sfld: "沖縄県那覇市で発見された更新世の人骨の化石の名称は？",
    star: 2,
    theme: "旧石器時代の遺跡",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note14",
    flds: [
      "日本における旧石器時代の文化の存在が明らかとなるきっかけになった、群馬県の遺跡は？",
      "岩宿遺跡",
      "いわじゅくいせき",
    ],
    hnref: 8,
    sfld: "日本における旧石器時代の文化の存在が明らかとなるきっかけになったのは群馬県の□遺跡の発掘調査の結果である。 に当てはまるのは□",
    star: 3,
    theme: "旧石器時代の遺跡",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note15",
    flds: ["岩宿遺跡を発見した人物は？", "相沢忠洋", "あいざわただひろ"],
    hnref: 8,
    sfld: "岩宿遺跡を発見した人物は？",
    star: 2,
    theme: "旧石器時代の遺跡",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note16",
    flds: [
      "更新世の時期に人類が原石を打ち欠いて使用していた石器の名称は？",
      "打製石器",
      "だせいせっき",
    ],
    hnref: 2,
    sfld: "更新世の時期に人類が原石を打ち欠いて使用していた石器の名称は？",
    star: 3,
    theme: "打製石器",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note17",
    flds: [
      "打製石器のみが使用されていた時代を特になんと呼ぶ？",
      "旧石器時代",
      "きゅうせっきじだい",
    ],
    hnref: 2,
    sfld: "打製石器のみが使用されていた時代を特になんと呼ぶ？",
    star: 3,
    theme: "打製石器",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note18",
    flds: [
      "旧石器時代の人類は何をおこなって生計を立てていた？",
      "狩猟・採取",
      "しゅりょう・さいしゅ",
    ],
    hnref: 5,
    sfld: "旧石器時代の人類は何をおこなって生計を立てていた？",
    star: 3,
    theme: "旧石器と縄文の生活",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note19",
    flds: [
      "旧石器時代の石器のうち、獲物の肉や毛皮、樹皮の切断に用いられたとされているものの名称は？",
      "ナイフ形石器",
    ],
    hnref: 2,
    sfld: "旧石器時代の石器のうち、獲物の肉や毛皮、樹皮の切断に用いられたとされているものの名称は？",
    star: 2,
    theme: "打製石器",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note20",
    flds: [
      "旧石器時代の石器のうち、槍先につけて使用されたとされているものの名称は？",
      "尖頭器",
      "せんとうき",
    ],
    hnref: 2,
    sfld: "旧石器時代の石器のうち、槍先につけて使用されたとされているものの名称は？",
    star: 2,
    theme: "打製石器",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "note21",
    flds: [
      "旧石器時代の石器のうち、木や骨などといった棒状のものに小石器をはめ込んで使われていたとされているものの名称は？",
      "細石器",
      "さいせっき",
    ],
    hnref: 2,
    sfld: "旧石器時代の石器のうち、木や骨などといった棒状のものに小石器をはめ込んで使われていたとされているものの名称は？",
    star: 2,
    theme: "打製石器",
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

const chapter3Notes = [
  createNoteData(
    "水稲耕作が日本で定着してから古墳が作られるまでの時代区分は？",
    "弥生時代",
    "弥生時代",
    3
  ),
];

export const seedSampleNotesToChapter1 = functions.https.onRequest(
  async (req, res) => {
    try {
      await seedNotes("chapter1", chapter1Notes);
      res.status(200).send("Chapter 1 notes seeded.");
    } catch (err) {
      console.error(err);
      res.status(500).send("Error seeding Chapter 1 notes.");
    }
  }
);

export const seedNotesToChapter3 = functions.https.onRequest(
  async (req, res) => {
    try {
      await seedNotes("chapter3", chapter3Notes);
      res.status(200).send("Chapter 3 notes seeded.");
    } catch (err) {
      console.error(err);
      res.status(500).send("Error seeding Chapter 3 notes.");
    }
  }
);
