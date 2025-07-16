#[cfg(test)]
mod tests {
    // === Imports ===
    use dojo::model::{ModelStorage, ModelStorageTest};
    use dojo::world::WorldStorageTrait;
    use dojo_cairo_test::{
        spawn_test_world, NamespaceDef, TestResource, ContractDef, ContractDefTrait, WorldStorageTestTrait
    };
    use starknet::{contract_address_const, testing, get_block_timestamp};

    // Models 
    use zapp_quiz::models::analytics_model::{DailyStats, CreatorStats, m_CreatorStats, PlatformStats, m_PlatformStats, QuestionResults};
    
    use zapp_quiz::models::quiz_model::{Quiz, m_Quiz, QuizCounter, m_QuizCounter, RewardSettings, PrizeDistribution};
    
    use zapp_quiz::models::question_model::{Question, m_Question, QuestionType};
    
    use zapp_quiz::models::system_model::{PlatformConfig, m_PlatformConfig};

    use zapp_quiz::models::game_model::{GameSession, m_GameSession, LivePlayerState, m_LivePlayerState, GameConfig, m_GameConfig};

    use zapp_quiz::models::player_model::{Player, m_Player};

    use zapp_quiz::interfaces::IZappQuiz::{IZappQuiz, IZappQuizDispatcher, IZappQuizDispatcherTrait};
   
    use zapp_quiz::models::question_model::QuestionTrait;

    use zapp_quiz::systems::ZappQuiz::ZappQuiz;

    // === Define Resources ===
    fn namespace_def() -> NamespaceDef {
        let ndef = NamespaceDef {
            namespace: "zapp_quiz",
            resources: [
                // Quiz related models
                TestResource::Model(m_Quiz::TEST_CLASS_HASH),
                TestResource::Model(m_QuizCounter::TEST_CLASS_HASH),
                TestResource::Model(m_Question::TEST_CLASS_HASH),
                
                // Analytics models
                TestResource::Model(m_CreatorStats::TEST_CLASS_HASH),
                TestResource::Model(m_PlatformStats::TEST_CLASS_HASH),
                
                // System models
                TestResource::Model(m_PlatformConfig::TEST_CLASS_HASH),
                
                // Game models (add these if used by your contract)
                TestResource::Model(m_GameSession::TEST_CLASS_HASH),
                TestResource::Model(m_LivePlayerState::TEST_CLASS_HASH),
                TestResource::Model(m_GameConfig::TEST_CLASS_HASH),
                TestResource::Model(m_Player::TEST_CLASS_HASH),
                
                // Events
                TestResource::Event(ZappQuiz::e_QuizCreated::TEST_CLASS_HASH),
                
                // Contract
                TestResource::Contract(ZappQuiz::TEST_CLASS_HASH),
            ]
            .span(),
        };
        ndef
    }

    fn contract_defs() -> Span<ContractDef> {
        [
            ContractDefTrait::new(@"zapp_quiz", @"ZappQuiz")
                .with_writer_of([dojo::utils::bytearray_hash(@"zapp_quiz")].span())
        ]
            .span()
    }
    
    #[test]
    fn test_create_quiz() {
        let ndef = namespace_def();
        let mut world = spawn_test_world([ndef].span());
        world.sync_perms_and_inits(contract_defs());
        
        let (contract_address, _) = world.dns(@"ZappQuiz").unwrap();
        let actions_system = IZappQuizDispatcher { contract_address };
        
        // Test creating a new quiz ID
        let caller = contract_address_const::<'TestUser'>();
        testing::set_contract_address(caller);
        
        // let quiz_id = actions_system.create_new_quiz_id();
        // assert(quiz_id == 1, 'First quiz ID should be 1');
        
        // let quiz_id_2 = actions_system.create_new_quiz_id();
        // assert(quiz_id_2 == 2, 'Second quiz ID should be 2');

        // let reward_settings = RewardSettings {
        //     has_rewards: true,
        //     token_address: contract_address_const::<'Akos'>(),
        //     reward_amount: 2000,
        //     distribution_type: PrizeDistribution::WinnerTakesAll,
        //     number_of_winners: 1,
        //     prize_percentage: ArrayTrait::new(),
        //     min_players: 3,
        // };
        
        let quiz_id = actions_system.create_quiz("Bitcoiners", "Quiz on the history of bitcoin", "History", false, 100000, 10, false, caller, 2000, true, PrizeDistribution::WinnerTakesAll, 1, ArrayTrait::new(), 3);

        let quiz = actions_system.get_quiz(quiz_id);

        assert!(quiz.quiz_details.quiz_title == "Bitcoiners", "Quiz title should be Bitcoiners");
        assert!(quiz.quiz_details.description == "Quiz on the history of bitcoin", "Quiz description should be Quiz on the history of bitcoin");
        assert!(quiz.quiz_details.category == "History", "Quiz category should be History");
        assert!(quiz.quiz_details.visibility == false, "Quiz visibility should be false");
        assert!(quiz.default_duration == 100000, "Quiz default duration should be 100000");
        assert!(quiz.default_max_points == 10, "Quiz default max points should be 10");
        assert!(quiz.custom_timing == false, "Quiz custom timing should be false");
        assert!(quiz.creator == caller, "Quiz creator should be TestUser");
        assert!(quiz.reward_settings.has_rewards == true, "Quiz has rewards should be true");
        assert!(quiz.reward_settings.token_address == contract_address_const::<'Akos'>(), "Quiz token address should be Akos");
        assert!(quiz.reward_settings.reward_amount == 2000, "Quiz reward amount should be 2000");
        assert!(quiz.reward_settings.distribution_type == PrizeDistribution::WinnerTakesAll, "Quiz distribution type should be WinnerTakesAll");
        assert!(quiz.reward_settings.number_of_winners == 1, "Quiz number of winners should be 1");
        assert!(quiz.reward_settings.prize_percentage.len() == 0, "Quiz prize percentage should be empty");
        assert(quiz.reward_settings.min_players == 3, 'Quiz min players should be 3');
        
    }
}