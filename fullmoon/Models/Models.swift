//
//  Models.swift
//  fullmoon
//
//  Created by Jordan Singer on 10/4/24.
//

import Foundation
import MLXLMCommon

public extension ModelConfiguration {
    enum ModelType {
        case regular, reasoning
    }

    var modelType: ModelType {
        switch self {
        case .deepseek_r1_distill_qwen_1_5b_4bit: .reasoning
        case .deepseek_r1_distill_qwen_1_5b_8bit: .reasoning
        case .qwen3_1_7b_4bit: .reasoning
        case .qwen3_0_6b_4bit: .reasoning
        case .qwen3_0_6b_bf16: .reasoning
        case .qwen3_1_7b_abliterated_bf16: .reasoning
        case .qwen3_4b_4bit: .reasoning
        default: .regular
        }
    }
}

extension ModelConfiguration: @retroactive Equatable {
    public static func == (lhs: MLXLMCommon.ModelConfiguration, rhs: MLXLMCommon.ModelConfiguration) -> Bool {
        return lhs.name == rhs.name
    }

    public static let llama_3_2_1b_4bit = ModelConfiguration(
        id: "mlx-community/Llama-3.2-1B-Instruct-4bit"
    )

    public static let llama_3_2_3b_4bit = ModelConfiguration(
        id: "mlx-community/Llama-3.2-3B-Instruct-4bit"
    )

    public static let deepseek_r1_distill_qwen_1_5b_4bit = ModelConfiguration(
        id: "mlx-community/DeepSeek-R1-Distill-Qwen-1.5B-4bit"
    )
    
    public static let deepseek_r1_distill_qwen_1_5b_8bit = ModelConfiguration(
        id: "mlx-community/DeepSeek-R1-Distill-Qwen-1.5B-8bit"
    )
    
    public static let qwen3_1_7b_4bit = ModelConfiguration(
        id: "mlx-community/Qwen3-1.7B-4bit"
    )
    
    public static let qwen3_0_6b_4bit = ModelConfiguration(
        id: "mlx-community/Qwen3-0.6B-4bit"
    )
    
    public static let qwen3_0_6b_bf16 = ModelConfiguration(
        id: "mlx-community/Qwen3-0.6B-bf16"
    )
    
    public static let qwen3_1_7b_abliterated_bf16 = ModelConfiguration(
        id: "mlx-community/Josiefied-Qwen3-1.7B-abliterated-v1-bf16"
    )
    
    public static let qwen3_4b_4bit = ModelConfiguration(
        id: "mlx-community/Qwen3-4B-4bit"
    )

    public static var availableModels: [ModelConfiguration] = [
        llama_3_2_1b_4bit,
        llama_3_2_3b_4bit,
        deepseek_r1_distill_qwen_1_5b_4bit,
        deepseek_r1_distill_qwen_1_5b_8bit,
        qwen3_1_7b_4bit,
        qwen3_0_6b_4bit,
        qwen3_0_6b_bf16,
        qwen3_1_7b_abliterated_bf16,
        qwen3_4b_4bit
    ]

    public static var defaultModel: ModelConfiguration {
        llama_3_2_1b_4bit
    }

    public static func getModelByName(_ name: String) -> ModelConfiguration? {
        if let model = availableModels.first(where: { $0.name == name }) {
            return model
        } else {
            return nil
        }
    }

    func getPromptHistory(thread: Thread, systemPrompt: String) -> [[String: String]] {
        var history: [[String: String]] = []

        // system prompt
        history.append([
            "role": "system",
            "content": systemPrompt,
        ])

        // messages
        for message in thread.sortedMessages {
            let role = message.role.rawValue
            history.append([
                "role": role,
                "content": formatForTokenizer(message.content), // Remove think tags and add a space before each message to fix the Jinja chat template issue.
            ])
        }

        return history
    }

    // TODO: Remove this function when Jinja gets updated
    func formatForTokenizer(_ message: String) -> String {
        if self.modelType == .reasoning {
            return " " + message
                .replacingOccurrences(of: "<think>", with: "")
                .replacingOccurrences(of: "</think>", with: "")
        }
        
        return message
    }

    /// Returns the model's approximate size, in GB.
    public var modelSize: Decimal? {
        switch self {
        case .llama_3_2_1b_4bit: return 0.7
        case .llama_3_2_3b_4bit: return 1.8
        case .deepseek_r1_distill_qwen_1_5b_4bit: return 1.0
        case .deepseek_r1_distill_qwen_1_5b_8bit: return 1.9
        case .qwen3_1_7b_4bit: return 1.0
        case .qwen3_0_6b_4bit: return 0.5
        case .qwen3_0_6b_bf16: return 0.6
        case .qwen3_1_7b_abliterated_bf16: return 1.7
        case .qwen3_4b_4bit: return 0.629
        default: return nil
        }
    }
}
