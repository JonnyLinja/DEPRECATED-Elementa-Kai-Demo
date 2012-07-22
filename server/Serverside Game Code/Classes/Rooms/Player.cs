using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PlayerIO.GameLibrary;

namespace MyGame {
    public class Player : BasePlayer {
        public const int maxCount = 31; //if send every 33ms, then 1 second to calculate it
        public long[] receivedSyncTimes = new long[maxCount];
        public int receivedSyncCount = 0;
        public int ignoreCount = 100; //if send every 33ms, then 3.3 seconds of ignore to stabilize connection
    }
}
