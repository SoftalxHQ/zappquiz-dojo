use starknet::{ContractAddress};

// Enhanced Achievement System
#[derive(Copy, Drop, Serde, Debug, Introspect)]
pub enum AchievementType {
    FirstWin,                           
    SpeedDemon,                         
    PerfectScore,                       
    Consistent,                         
    TriviaMaster,                       
    BigWinner,                          
    CategoryExpert,                     
    QuickDraw,
    // New achievements
    Streak10,                           // 10 game win streak
    Streak25,                           // 25 game win streak
    TopPerformer,                       // Top 3 finish 50 times
    QuizCreator,                        // Created first quiz
    PopularCreator,                     // Quiz played by 100+ players
    CategoryMaster,                     // Master of 5 different categories
    WeeklyChampion,                     // Won most games in a week
    MonthlyLegend,                      // Won most games in a month
    LightningRound,                     // Answered 10 questions in under 30 seconds
    Comeback,                           // Won after being last place
}

#[derive(Copy, Drop, Serde, Debug, Introspect)]
pub enum PlayerQuizCreationStatus {
    Active,
    Ended,
    Archived,                          
}

#[derive(Copy, Drop, Serde, Debug, Introspect)]
pub enum PlayerTier {
    Bronze,
    Silver, 
    Gold,
    Platinum,
    Diamond,
    Master,
}

#[derive(Copy, Drop, Serde, Debug, Introspect)]
pub enum QuizDifficulty {
    Easy,
    Medium,
    Hard,
    Expert,
}

#[derive(Serde, Copy, Drop, Introspect, PartialEq)]
#[dojo::model]
pub struct PlayerCounter {
    #[key]
    pub id: felt252,
    pub current_val: u256,
}

#[derive(Clone, Drop, Serde, Debug, Introspect)]
#[dojo::model]
pub struct Player {
    #[key]
    pub address: ContractAddress,
    pub nickname: felt252, 
    pub avatar_url: ByteArray,
    pub created_at: u64,                    // When player joined
    pub total_games_played: u32,
    pub total_wins: u32,
    pub total_losses: u32,
    pub current_win_streak: u32,            // Current consecutive wins
    pub best_win_streak: u32,               // Best ever win streak
    pub total_score: u64,                   // Increased from u32 for larger scores
    pub average_score: u32,                 // Calculated average score per game
    pub total_time_played: u64,
    pub average_answer_time: u32,           // Average time per answer in seconds
    pub last_active: u64,
    pub achievements_completed: u32,
    pub player_tier: PlayerTier,            // Ranking tier
    pub tier_points: u32,                   // Points toward next tier
    pub total_earnings: u256,               // Total crypto earned
    pub favorite_category: felt252,         // Most played category
    pub games_created: u32,                 // Number of quizzes created
    pub is_active: bool,                    // Account status
    
    // Creator-specific fields (optional, only populated if player creates quizzes)
    pub creator_profile: Option<CreatorProfile>,
}

// Creator profile struct that gets embedded in Player
#[derive(Copy, Drop, Serde, Debug, Introspect)]
pub struct CreatorProfile {
    pub creator_since: u64,                 // When they created their first quiz
    pub verified: bool,                     // Creator verification status
    pub verification_level: CreatorTier,    // Bronze, Silver, Gold, Platinum
    pub total_quiz_plays: u64,              // Sum of all plays across all quizzes
    pub total_creator_earnings: u256,       // Total earnings from quiz creation
    pub average_quiz_rating: u32,           // Average rating across all quizzes (scaled by 100)
    pub total_quiz_ratings: u32,
    pub featured_quizzes: u32,              // Number of featured quizzes
    pub monthly_quiz_limit: u32,            // Quiz creation limit per month
    pub quizzes_created_this_month: u32,
    pub creator_rank: u32,                  // Global creator ranking
    pub specialization_category: felt252,   // Main category they create for
    pub creator_badge: felt252,             // Special badge/title
    pub follower_count: u32,                // If you have a follow system
    pub total_player_hours: u64,            // Total hours players spent on their quizzes
    pub quality_score: u32,                 // Algorithm-based quality score
    pub last_quiz_created: u64,
    pub creator_achievements: u32,          // Number of creator-specific achievements
}

// Creator tier enum
#[derive(Copy, Drop, Serde, Debug, Introspect)]
pub enum CreatorTier {
    Unverified,
    Bronze,
    Silver, 
    Gold,
    Platinum,
    Diamond,
}

// Enhanced PlayerAchievement to handle both player and creator achievements
#[derive(Copy, Drop, Serde, Debug)]
#[dojo::model]
pub struct PlayerAchievement {
    #[key]
    pub player: ContractAddress,
    #[key]
    pub achievement_type: AchievementType,  // Now includes creator achievements
    pub earned_at: u64,
    pub progress: u32,
    pub target: u32,                        // Target value for achievement
    pub completed: bool,
    pub reward_claimed: bool,               // Whether reward was claimed
    pub reward_amount: u256,                // Reward for this achievement
    pub is_creator_achievement: bool,       // Flag to distinguish achievement types
}

// pub trait PlayerTrait{
//     fn initialize_creator_profile(ref self: ContractState, current_time: u64);
//     fn is_creator(self: @ContractState) -> bool;
//     fn get_creator_profile(self: @ContractState) -> Option<CreatorProfile>;
    
// }

// impl PlayerImpl of PlayerTrait {
//     // Initialize creator profile when player creates their first quiz
//     fn initialize_creator_profile(ref self: ContractState, current_time: u64) {
//         if self.creator_profile.is_none() {
//             self.creator_profile = Option::Some(CreatorProfile {
//                 creator_since: current_time,
//                 verified: false,
//                 verification_level: CreatorTier::Unverified,
//                 total_quiz_plays: 0,
//                 total_creator_earnings: 0,
//                 average_quiz_rating: 0,
//                 total_quiz_ratings: 0,
//                 featured_quizzes: 0,
//                 monthly_quiz_limit: 10, // Default limit
//                 quizzes_created_this_month: 0,
//                 creator_rank: 0,
//                 specialization_category: 0,
//                 creator_badge: 0,
//                 follower_count: 0,
//                 total_player_hours: 0,
//                 quality_score: 0,
//                 last_quiz_created: current_time,
//                 creator_achievements: 0,
//             });
//         }

//     }
    
//     // Check if player is a creator
//     fn is_creator(self: @ContractState) -> bool {
//         if self.creator_profile{
//             true
//         }else{
//             false
//         }
//     }
    
//     // Get creator profile reference
//     fn get_creator_profile(self: @ContractState) -> Option<CreatorProfile> {
//         self.creator_profile
//     }
// }

// Enhanced PlayerQuizCreation remains the same but now works with creator profile
#[derive(Copy, Drop, Serde, Debug, Introspect)]
#[dojo::model]
pub struct PlayerQuizCreation {
    #[key]
    pub player: ContractAddress,
    #[key]
    pub quiz_id: felt252,                   // Unique quiz ID instead of title
    pub quiz_title: felt252,
    pub created_at: u64,
    pub updated_at: u64,                    // Last modification time
    pub num_of_questions: u32,
    pub times_played: u32,                  // Renamed for clarity
    pub total_players: u32,
    pub total_rewards_distributed: u256,
    pub status: PlayerQuizCreationStatus,
    pub difficulty: QuizDifficulty,         // Quiz difficulty level
    pub category: felt252,                  // Quiz category
    pub average_score: u32,                 // Average score of players
    pub average_completion_time: u64,       // Average time to complete
    pub creator_earnings: u256,             // How much creator earned
    pub is_featured: bool,                  // Whether quiz is featured
    pub rating: u8,                         // User rating out of 5
    pub total_ratings: u32,                 // Number of ratings received
}