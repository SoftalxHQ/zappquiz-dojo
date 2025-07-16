use zapp_quiz::models::question_model::QuestionType;
use zapp_quiz::models::quiz_model::Quiz;
use zapp_quiz::models::quiz_model::PrizeDistribution;
use starknet::ContractAddress;

#[starknet::interface]
pub trait IZappQuiz<T> {
    fn create_quiz(
    ref self: T,
    title: ByteArray,
    description: ByteArray,
    category: ByteArray,
    public: bool,
    default_duration: u256,
    default_max_points: u16,
    custom_timing: bool,
    creator: ContractAddress,
    // reward_settings: RewardSettings,
    amount: u256,
    has_rewards: bool,
    distribution_type: PrizeDistribution,
    number_of_winners: u8,
    prize_percentage: Array<u8>,
    min_players: u32,
    ) -> u256;

    fn get_quiz(self: @T, quiz_id: u256) -> Quiz;

    fn add_question_to_quiz(
        ref self: T,
        quiz_id: u256,
        text: ByteArray,
        question_type: QuestionType,
        options: Array<ByteArray>,
        correct_option: u8,
        duration_seconds: u256,
        point: u256,
        max_points: u256,
    ) -> bool ;

    fn remove_question_from_quiz(
        ref self: T,
        quiz_id: u256,
        question_index: u32,
    ) -> bool;

    fn create_new_quiz_id(ref self: T,) -> u256;

    fn create_new_question_id(ref self: T,) -> u256;

}