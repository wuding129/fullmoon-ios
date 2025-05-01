# Fullmoon iOS 应用 - 产品与技术规划：本地 AI 引擎

**版本：** 1.1
**日期：** 2025年5月1日
**作者：** GitHub Copilot (生成)

## 1. 愿景

打造一款功能强大、用户友好的 iOS 应用（"Fullmoon"），利用本地 AI 模型的能力，让用户能够直接在设备上执行文本生成、图像创建、查询本地知识库以及利用 AI 代理等任务，确保隐私、离线可用性，并提供与领先的云 AI 服务相媲美的无缝用户体验。

## 2. 核心原则

*   **本地优先：** 优先考虑设备端处理，以保护隐私、提高速度（模型加载后）并实现离线访问。
*   **简洁清晰：** 尽管底层复杂，仍保持干净、直观、整洁的用户界面。遵循 iOS 人机界面指南。
*   **统一体验：** 确保所有功能（聊天、图像生成、知识库、代理）采用一致的设计语言和交互模式。
*   **性能透明：** 清晰传达模型下载状态、处理时间以及潜在的资源使用情况。在适当情况下提供用户控制选项。
*   **迭代开发：** 从核心功能开始，根据用户反馈和技术可行性逐步增加功能。
*   **模块化：** 设计架构以便轻松集成不同的本地模型（LLM、扩散模型等），特别是那些针对移动设备优化后的模型。

## 3. 当前技术基础

基于现有代码分析，Fullmoon iOS 应用已经具备以下技术基础：

* **MLX 推理框架**：使用 Apple 的 MLX 库为基础的推理引擎，专为 Apple Silicon 优化，提供高效的本地模型执行。
* **模型支持**：已集成多种小型高效 LLM，包括：
  * Llama 3.2 (1B 和 3B 版本)
  * DeepSeek R1 系列
  * Qwen3 系列 (0.6B, 1.7B, 4B 等不同规格)
* **量化支持**：已支持 4-bit、8-bit 和 BFloat16 等不同量化级别，在保持模型质量的同时优化性能和存储。
* **多平台支持**：单一代码库同时支持 iOS、macOS 和 visionOS，通过自适应布局优化不同平台体验。
* **数据持久化**：使用 SwiftData 进行聊天历史和应用状态管理，确保数据持久性和查询效率。
* **Markdown 渲染**：集成 MarkdownUI 提供高质量的富文本渲染，支持代码高亮和格式化输出。
* **已实现功能**：
  * **多会话管理**：支持创建、重命名和删除多个独立聊天会话
  * **流式生成**：实时字符级响应显示，支持中途取消生成
  * **系统提示管理**：可自定义系统提示词，优化AI响应质量
  * **模型管理**：下载、切换和管理多个本地模型
  * **GPU资源监控**：实时监测和显示模型执行时的GPU使用情况
  * **Shortcuts集成**：通过系统级Shortcuts支持与Siri交互
  * **个性化设置**：支持主题颜色、字体风格等UI定制选项

## 4. 功能路线图（迭代方法）

此路线图基于已有基础上展开，遵循渐进式开发策略，优先利用已有的开源技术。

### 迭代 1：优化现有文本聊天功能（已基本实现）

*   **目标：** 巩固和优化现有的本地 LLM 交互能力。
*   **功能：**
    *   **已实现：** 
      * 多会话管理（创建、重命名、搜索和删除会话）
      * 系统提示词自定义
      * 流式文本生成与中断控制
      * Markdown渲染与代码高亮
      * 性能监控（GPU使用率、生成速度）
      * 思考过程展示（特殊标签处理）
    *   **待优化：**
      * 改进系统提示模板库，提供更多场景化模板
      * 优化模型切换时的内存管理
      * 增强错误处理和恢复机制
*   **技术方案：** 
    * 继续基于 MLX 框架，优化模型推理和内存管理
    * 实现更高效的模型缓存策略
    * 增强异常情况下的用户体验

### 迭代 2：知识增强与本地 RAG

*   **目标：** 为应用增加检索增强生成 (RAG) 能力，让模型能够参考本地知识源回答问题。
*   **功能：**
    *   实现本地文档导入系统（支持 TXT、Markdown、PDF）
    *   文档索引与向量存储
    *   集成小型高效嵌入模型
    *   上下文自动扩充功能（根据查询自动提取相关文档片段）
    *   知识源管理界面（添加、删除、更新本地知识库）
    *   引用追踪（显示回答来源于哪些文档）
*   **技术方案：**
    * 集成轻量级嵌入模型（如 E5-small）
    * 使用 Swift-MXLangChain 或自建 RAG 流程
    * 实现高效的向量存储和检索系统
    * 优化文档分块和相关性排序算法

### 迭代 3：本地图像生成

*   **目标：** 引入设备端图像生成能力。
*   **功能：**
    *   集成一个本地图像生成模型（移动优化的 Stable Diffusion 变体）。
    *   专门的图像生成 UI 部分。
    *   将生成的图像保存到设备照片库的功能。
*   **技术方案：**
    * 使用开源的 [Apple/ml-stable-diffusion](https://github.com/apple/ml-stable-diffusion) 作为图像生成基础
    * 考虑集成以下优化版本:
      * Tiny SD (极小版本 Stable Diffusion)
      * [SD-Turbo](https://huggingface.co/stabilityai/sd-turbo) (单步扩散模型)
      * 使用 CoreML 编译后的模型减少内存消耗和提升速度
    * 实现渐进式预览，让用户在生成过程中看到图像逐步构建

### 迭代 4：本地知识库 (RAG)

*   **目标：** 允许用户与自己的本地文档进行聊天。
*   **功能：**
    *   提供导入用户文档的机制（初期支持纯文本，后续支持 PDF）。
    *   为导入的文档进行本地索引/嵌入生成处理。
    *   与聊天界面集成：
        *   提供为聊天会话选择特定知识库来源的选项。
        *   实现检索增强生成 (RAG)，在 LLM 响应中使用文档上下文。
*   **技术方案：**
    * 利用 [Swift-MXLangChain](https://github.com/ml-explore/swift-mxlangchain) 实现 RAG 系统
    * 使用 Apple 的 NaturalLanguage 框架进行文本分析和处理
    * 集成 [FAISS](https://github.com/facebookresearch/faiss) 的 Swift 绑定或使用 [USSearch](https://github.com/unum-cloud/usearch) 作为向量搜索引擎
    * 利用 [E5-small](https://huggingface.co/intfloat/e5-small) 等小型嵌入模型，确保嵌入生成过程轻量高效

### 迭代 5：基础 Agent 功能

*   **目标：** 为特定任务引入初步的 AI 代理能力。
*   **功能：**
    *   定义一组简单的、预定义的代理任务（总结文本、提取要点、翻译文本等）。
    *   在聊天界面内集成代理调用。
    *   允许用户为代理任务提供输入。
*   **技术方案：**
    * 基于现有的"思考"功能（代码中已有 `isThinking` 状态）扩展 Agent 能力
    * 使用 JSON 格式定义工具和任务，实现标准化的 Agent 接口
    * 集成 ChatML 格式支持，以便更好地处理工具调用和响应
    * 借鉴 [CrewAI](https://github.com/crewai/crewai) 的设计思路，为本地 Agent 系统构建基础框架

## 5. 核心技术栈规划

### LLM 框架与推理引擎

* **主推理引擎：** MLX（已实现并优化）
* **辅助引擎选项：**
  * [llama.cpp](https://github.com/ggerganov/llama.cpp) - 用于支持更多模型格式 
  * [CoreML](https://developer.apple.com/documentation/coreml) - 用于针对 Apple 硬件优化的模型
  * [MLC-LLM](https://github.com/mlc-ai/mlc-llm) - 高性能跨平台推理引擎
  * [Whisper.cpp](https://github.com/ggerganov/whisper.cpp) - 用于语音识别功能
  * [SwiftLLM](https://github.com/huggingface/swift-transformers) - HuggingFace的Swift原生实现

### 模型支持扩展计划

* **文本模型增强：**
  * 考虑添加 [Phi-3](https://huggingface.co/microsoft/phi-3-mini-4k-instruct) 系列小型模型
  * 探索 [MiniCPM](https://github.com/OpenBMB/MiniCPM) 等高效小型模型
  * 评估 [Gemma 3]系列模型
  * 考虑 [TinyLlama](https://huggingface.co/TinyLlama/TinyLlama-1.1B-Chat-v1.0) 等超轻量模型
  * 为特定任务定制微调小型专用模型

* **图像生成模型：**
  * SD-Turbo（单步扩散）
  * Tiny SD（更小版本）
  * [PixArt-Alpha](https://github.com/PixArt-alpha/PixArt-alpha)（如有轻量版）
  * [Latent Consistency Model](https://github.com/luosiallen/latent-consistency-model)（LCM，高速单步扩散）
  * [SDXL-Lightning](https://huggingface.co/ByteDance/SDXL-Lightning)（4-8步高速生成）
  * [DiT](https://github.com/facebookresearch/DiT)（Diffusion Transformers，适合移动设备）
  
* **嵌入模型：**
  * [E5-small](https://huggingface.co/intfloat/e5-small)（轻量级通用嵌入）
  * [MiniLM-L6](https://huggingface.co/microsoft/MiniLM-L6-v2)（高效文本嵌入）
  * [Nomic-Embed-Text](https://huggingface.co/nomic-ai/nomic-embed-text-v1)（如有轻量版）
  * [GTE-small](https://huggingface.co/thenlper/gte-small)（高效通用文本嵌入）
  * [BGE-M3](https://huggingface.co/BAAI/bge-m3)（多语言支持，适合中文场景）
  * [Jina Embeddings](https://huggingface.co/jinaai/jina-embeddings-v2-small-en)（小型版本，高性能）

### 性能优化策略

* **已实现优化：**
  * 模型量化（4-bit、8-bit）支持
  * GPU 使用率监控
  * 流式生成机制
  * 生成取消控制
  
* **计划实施：**
  * **模型量化增强：** 评估 [GPTQ](https://github.com/IST-DASLab/gptq) 和 [AWQ](https://github.com/mit-han-lab/llm-awq) 等高级量化技术
  * **智能缓存系统：** 根据使用频率和最近活动动态管理模型加载/卸载
  * **特定芯片优化：** 针对不同代的 Apple Silicon（M1/M2/M3 系列）优化执行策略
  * **批处理优化：** 改进输入处理以提高吞吐量
  * **推理加速技术：** 实现 [Speculative Decoding](https://arxiv.org/abs/2211.17192) 和 [Medusa](https://sites.google.com/view/medusa-llm) 等先进推理加速技术
  * **内存管理：** 优化长上下文处理中的内存使用
  * **低功耗模式：** 在电池电量低时提供性能/功耗平衡选项

## 6. UI/UX 设计规划

*   **当前 UI 基础：**
    * 基于 SwiftUI 的现代响应式界面
    * 自适应布局支持（iPhone/iPad/Mac/visionOS）
    * 主题颜色和字体风格定制
    * Markdown 渲染与代码高亮
    
*   **设计增强计划：**
    * **统一设计语言：** 完善 Fullmoon 专属设计系统，确保跨功能视觉一致性
    * **引导式体验：** 优化首次使用流程，增加功能发现机制
    * **状态反馈增强：** 改进长时间任务的进度和状态可视化
    * **功能区整合：** 为新增功能（图像生成、知识库查询）设计一致的访问入口
    * **多模态切换：** 优化文本与图像生成之间的切换体验
    * **手势优化：** 增强触摸交互，提供更多手势快捷操作
    * **无障碍优化：** 改进 VoiceOver 支持和动态字体兼容性
    * **原生集成深化：** 增加对系统特性（Share Extensions、焦点模式）的支持

## 7. 开发与实施时间表

| 迭代阶段 | 预计时长 | 主要开发目标 |
|---------|---------|------------|
| 迭代 1 | 2-3 周 | 优化核心文本聊天功能，改进现有代码 |
| 迭代 2 | 3-4 周 | 增强多会话管理和模型管理界面 |
| 迭代 3 | 4-5 周 | 实现基础图像生成功能 |
| 迭代 4 | 5-6 周 | 开发本地知识库集成系统 |
| 迭代 5 | 4-5 周 | 构建基础 Agent 功能框架 |

## 8. 关键技术挑战与解决方案

* **内存管理：** 模型大小与设备内存限制的平衡
  * 解决方案：实现动态模型加载/卸载，分层执行策略，采用 [Attention Sinks](https://github.com/tomaarsen/attention_sinks) 等内存优化技术
  
* **电池消耗：** 本地推理对电池寿命的影响
  * 解决方案：批处理优化，模型选择智能化，后台任务管理，实现低功耗模式
  
* **用户体验连贯性：** 模型加载与执行延迟可能破坏体验流畅性
  * 解决方案：预加载常用模型，UI反馈优化，结果缓存策略，实现流式输出
  
* **存储管理：** 多模型并存对设备存储空间的压力
  * 解决方案：云端同步可选功能，智能本地存储管理，模型生命周期管理，增量更新机制
  
* **多模态集成：** 文本、图像和语音模型的协同工作
  * 解决方案：统一的多模态接口设计，模块化架构，高效的跨模态数据传输
  
* **隐私保护：** 确保用户数据在本地处理过程中的安全
  * 解决方案：实现端到端加密，沙盒化模型执行环境，透明的数据使用政策
  
* **模型更新：** 保持本地模型与最新研究进展同步
  * 解决方案：增量模型更新系统，差异化下载，模型版本管理

## 9. 结论

Fullmoon iOS 应用有潜力成为本地 AI 能力的典范，通过站在开源社区的肩膀上，我们可以构建一个功能强大且高效的应用。每个迭代都将带来新的能力，同时保持应用的高性能和用户友好特性。本规划提供了明确的技术路线图，确保开发团队能够有序地实现这一愿景。

最终目标是打造一款让用户惊叹的应用，它不仅展示了本地 AI 的潜力，还为用户提供了一个实用、安全且令人愉悦的工具，真正体现 AI 赋能个人设备的未来。
