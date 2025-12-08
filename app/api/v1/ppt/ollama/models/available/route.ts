import { NextRequest, NextResponse } from 'next/server';

/**
 * GET /api/v1/ppt/ollama/models/available
 * Fetches available Ollama models from local Ollama instance
 */
export async function GET(request: NextRequest) {
    try {
        const ollamaUrl = process.env.OLLAMA_URL || 'http://localhost:11434';

        const response = await fetch(`${ollamaUrl}/api/tags`, {
            method: 'GET',
        });

        if (!response.ok) {
            throw new Error(`Failed to fetch Ollama models: ${response.statusText}`);
        }

        const data = await response.json();
        const models = data.models?.map((model: any) => model.name) || [];

        return NextResponse.json(models);
    } catch (error: any) {
        console.error('Error fetching Ollama models:', error);
        return NextResponse.json(
            { error: error.message || 'Failed to fetch Ollama models. Make sure Ollama is running.' },
            { status: 500 }
        );
    }
}

/**
 * GET /api/v1/ppt/ollama/model/pull?model=<model_name>
 * Pulls an Ollama model
 */
export async function POST(request: NextRequest) {
    try {
        const { searchParams } = new URL(request.url);
        const model = searchParams.get('model');

        if (!model) {
            return NextResponse.json(
                { error: 'Model name is required' },
                { status: 400 }
            );
        }

        const ollamaUrl = process.env.OLLAMA_URL || 'http://localhost:11434';

        const response = await fetch(`${ollamaUrl}/api/pull`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ name: model }),
        });

        if (!response.ok) {
            throw new Error(`Failed to pull model: ${response.statusText}`);
        }

        // Stream the response
        return new Response(response.body, {
            headers: {
                'Content-Type': 'application/x-ndjson',
                'Transfer-Encoding': 'chunked',
            },
        });
    } catch (error: any) {
        console.error('Error pulling Ollama model:', error);
        return NextResponse.json(
            { error: error.message || 'Failed to pull model' },
            { status: 500 }
        );
    }
}
