//http://blue1st.hateblo.jp/entry/2016/08/23/235506

// 手をキー、その手が勝てる手をバリューとするマップ
const handMap = new Map([
  ['g', 'c'],
  ['c', 'p'],
  ['p', 'g'],
])

function janken(hand1, hand2) {
  throwIfUnkownHand(hand1, hand2)

  if (hand1 === hand2) {
    return 'draw'
  }

  const winnable = handMap.get(hand1)
  return winnable === hand2 ? 'win' : 'lose'
}

function throwIfUnkownHand(...hands) {
  hands.forEach(hand => {
    if (!handMap.has(hand)) {
      throw new Error(`Unkown hand: ${hand}`)
    }
  })
}

// --------------------------------------------------------

function test() {
  [
    ['g', 'g', 'draw'],
    ['g', 'p', 'lose'],
    ['g', 'c', 'win'],
    ['c', 'g', 'lose'],
    ['c', 'p', 'win'],
    ['c', 'c', 'draw'],
    ['p', 'g', 'win'],
    ['p', 'p', 'draw'],
    ['p', 'c', 'lose'],
  ]
  .forEach(([h1, h2, expected]) => {
    const actual = janken(h1, h2)
    console.assert(
      expected === actual,
      `${h1} vs ${h2} should be ${expected} but ${actual}`
    )
  })

  console.log('test ends successfully')
}

test()
